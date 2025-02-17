class_name CircuitDevice
extends Node2D

const SIG_LO := 0
const SIG_HI := ~0
const SIG_UNKNOWN := 1

var config := ConfigFile.new()
var cfg_name := ""
var top_left := Vector2i(0, 0)
var device_size := Vector2i(0, 0)

var description := ""
var pin_names: PackedStringArray = []
var pin_signals: PackedInt32Array = []

# r0 to r7 general-purpose registers.
var gpr := [0, 0, 0, 0, 0, 0, 0, 0]

var gnd_idx := -1
var vcc_idx := -1


func set_top_left(pos: Vector2i) -> void:
	self.top_left = pos


func _get_pin_sig(c: Vector2i) -> int:
	var pin = get_node(
		"/root/Node2D/Control/PinGrid/PinContainer" + str(c.x) + "x" + str(c.y)
	)
	return pin.sig


func _set_pin_sig(c: Vector2i, sig: int) -> void:
	var pin = get_node(
		"/root/Node2D/Control/PinGrid/PinContainer" + str(c.x) + "x" + str(c.y)
	)
	pin.sig = sig


func _load(cfg: String) -> void:
	config.load("res://devices/" + cfg + ".ini")

	# The first section contains the name of the device.
	cfg_name = config.get_sections()[0]
	name = cfg_name  # attribute 'name' can be changed by Godot.
	
	description = config.get_value(cfg_name, "description", "")

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


func pin_inputs() -> void:
	var bot_right := top_left + device_size
	var half_pins := len(pin_names) / 2
	for i in range(0, len(pin_names)):
		# Left side pins - move down from top-left.
		if i < half_pins:
			pin_signals[i] = _get_pin_sig(top_left + Vector2i(0, i + 1))
			#print(pin_signals[i])
			#print(top_left + Vector2i(0, i + 1))
		else:
			pin_signals[i] = _get_pin_sig(bot_right - Vector2i(0, i - half_pins + 1))
			#print(pin_signals[i])
			#print(bot_right - Vector2i(0, i - half_pins + 1))
	#print()


func pin_process() -> void:
	if not _working():
		return
	for key in config.get_section_keys(cfg_name + ".logic"):
		var value = config.get_value(cfg_name + ".logic", key)
		var value_args = Array(value.split(" ", false))

		var out_arr: Array
		var out_idx: int

		# Get the array element which will store the result.
		if key.begins_with("p"):  # pins
			out_arr = pin_signals
			out_idx = key.trim_prefix("p").to_int() - 1
		elif key.begins_with("r"):  # registers
			out_arr = gpr
			out_idx = key.trim_prefix("r").to_int()

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
		out_arr[out_idx] = value_args[0]


func pin_outputs() -> void:
	var bot_right := top_left + device_size
	var half_pins := len(pin_names) / 2
	for i in range(0, len(pin_names)):
		# Left side pins - move down from top-left.
		if i < half_pins:
			_set_pin_sig(top_left + Vector2i(0, i + 1), pin_signals[i])
		else:
			_set_pin_sig(bot_right - Vector2i(0, i - half_pins + 1), pin_signals[i])
