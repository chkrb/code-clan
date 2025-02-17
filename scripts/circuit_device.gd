class_name CircuitDevice
extends Node2D

const SIG_LO := 0
const SIG_HI := ~0
const SIG_UNKNOWN := 1

# TODO: get size from %PinGrid.pin_cell_size
const pin_cell_size := Vector2i(40, 40)

var placed := false

var config := ConfigFile.new()
var cfg_name := ""
var top_left := Vector2i(0, 0)
var device_size := Vector2i(0, 0)

var description := ""
var link := ""
var type := ""
var texture := ""
var pin_names: PackedStringArray = []
var pin_signals: PackedInt32Array = []

# r0 to r7 general-purpose registers.
var gpr: PackedInt32Array = [0, 0, 0, 0, 0, 0, 0, 0]

var gnd_idx := -1
var vcc_idx := -1


func _get_pin_sig(c: Vector2i) -> int:
	var pin = get_node(
		"/root/Node2D/Control/PinGrid/PinContainer" + str(c.x) + "x" + str(c.y)
	)
	return pin.sig if pin else SIG_UNKNOWN


func _set_pin_sig(c: Vector2i, sig: int) -> void:
	var pin = get_node(
		"/root/Node2D/Control/PinGrid/PinContainer" + str(c.x) + "x" + str(c.y)
	)
	if pin:
		pin.sig = sig


func load_cfg(cfg: String) -> void:
	config.load("res://devices/" + cfg + ".ini")

	# The first section contains the name of the device.
	cfg_name = config.get_sections()[0]
	name = cfg_name  # attribute 'name' can be changed by Godot.
	
	description = config.get_value(cfg_name, "description", "")
	link = config.get_value(cfg_name, "link", "")
	type = config.get_value(cfg_name, "type", "")
	texture = config.get_value(cfg_name, "texture", "")

	while true:
		var pname = config.get_value(
			cfg_name + ".pins", 
			"p" + str(len(pin_names) + 1),
		)
		if pname == null:
			break
		elif pname == "VCC":
			vcc_idx = len(pin_names)
		elif pname == "GND":
			gnd_idx = len(pin_names)
		pin_names.append(pname)
		pin_signals.append(SIG_UNKNOWN)

	# Number of pins must be even.
	assert(len(pin_names) % 2 == 0)


func _working() -> bool:
	return pin_signals[gnd_idx] == SIG_LO and pin_signals[vcc_idx] == SIG_HI


func set_top_left(pos: Vector2i) -> void:
	self.top_left = pos
	position = pos * pin_cell_size + pin_cell_size / 2


func pin_inputs() -> void:
	if not placed:
		return
	var pin_y := 0
	for i in range(0, len(pin_names)):
		# Left side pins - move down from top-left.
		if i < len(pin_names) / 2:
			pin_y += 1
			pin_signals[i] = _get_pin_sig(top_left + Vector2i(0, pin_y))
		else:
			pin_signals[i] = _get_pin_sig(top_left + Vector2i(device_size.x, pin_y))
			pin_y -= 1


func pin_process() -> void:
	if not _working():
		return
	for key in config.get_section_keys(cfg_name + ".logic"):
		var value = config.get_value(cfg_name + ".logic", key)
		var value_args = Array(value.split(" ", false))

		# Replace pins and registers with their respective values.
		for i in range(0, len(value_args)):
			var arg = value_args[i]
			if arg.begins_with("p"):  # pins
				value_args[i] = pin_signals[arg.trim_prefix("p").to_int() - 1]
			elif arg.begins_with("r"):  # registers
				value_args[i] = gpr[arg.trim_prefix("r").to_int()]

		# Evaluate the prefix expression.
		for i in range(len(value_args) - 1, -1, -1):
			if value_args[i] is not String:
				continue
			if value_args[i] == "NOT":
				value_args[i] = ~value_args[i + 1]
				value_args.remove_at(i + 1)
			elif value_args[i] == "AND":
				value_args[i] = value_args[i + 1] & value_args[i + 2]
				value_args.remove_at(i + 1)
				value_args.remove_at(i + 1)
			elif value_args[i] == "OR":
				value_args[i] = value_args[i + 1] | value_args[i + 2]
				value_args.remove_at(i + 1)
				value_args.remove_at(i + 1)
			elif value_args[i] == "XOR":
				value_args[i] = value_args[i + 1] ^ value_args[i + 2]
				value_args.remove_at(i + 1)
				value_args.remove_at(i + 1)

		# Only one element (that is, the result) should be left.
		assert(len(value_args) == 1)
		
		# Get the array element which will store the result.
		if key.begins_with("p"):  # pins
			var out_idx := key.trim_prefix("p").to_int() - 1
			pin_signals[out_idx] = value_args[0]
		elif key.begins_with("r"):  # registers
			var out_idx := key.trim_prefix("r").to_int()
			gpr[out_idx] = value_args[0]


func pin_outputs() -> void:
	if not placed:
		return
	var pin_y := 0
	for i in range(0, len(pin_names)):
		# Left side pins - move down from top-left.
		if i < len(pin_names) / 2:
			pin_y += 1
			_set_pin_sig(top_left + Vector2i(0, pin_y), pin_signals[i])
		else:
			_set_pin_sig(top_left + Vector2i(device_size.x, pin_y), pin_signals[i])
			pin_y -= 1


func _ready_visual() -> void:
	# The amount of space (in pin widths) the device takes up.
	device_size = Vector2i(2, 2)

	var sprite := Sprite2D.new()
	var pin_grid := $"/root/Node2D/Control/PinGrid"
	sprite.texture = ImageTexture.create_from_image(Image.load_from_file(
		"res://images/devices/" + texture
	))
	sprite.hframes = 2
	var frame_size := \
		sprite.texture.get_size() / Vector2(sprite.hframes, sprite.vframes)
	sprite.scale = Vector2(device_size * pin_cell_size) / frame_size
	sprite.centered = false
	add_child(sprite)

	set_top_left(top_left)


func _ready_logical() -> void:
	# The amount of space (in pin widths) the device takes up.
	device_size = Vector2i(5, len(pin_names) / 2)

	for i in range(len(pin_names) / 2):
		var pin_line = Line2D.new()
		pin_line.default_color = Color(0, 0, 0)
		pin_line.width = 5
		pin_line.add_point(Vector2i(0, i + 1) * pin_cell_size)
		pin_line.add_point(Vector2i(device_size.x, i + 1) * pin_cell_size)
		add_child(pin_line)
		
	var rect = ColorRect.new()
	rect.color = Color(0, 0, 0)
	rect.position = pin_cell_size / 2
	rect.size = (device_size - Vector2i(1, 0)) * pin_cell_size
	add_child(rect)

	var label := Label.new()
	label.text = cfg_name
	label.add_theme_font_size_override("font_size", 32)
	rect.add_child(label)

	set_top_left(top_left)


func _ready() -> void:
	if type == "Visual":
		_ready_visual()
	elif type == "Logical":
		_ready_logical()


func _process(delta: float) -> void:
	if type == "Visual":
		for child in get_children():
			if child is Sprite2D:
				child.frame = int(_working())
				return


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:
		placed = true
		print(top_left)
		print(_working())
