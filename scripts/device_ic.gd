class_name DeviceIC
extends CircuitDevice

@onready var pin_cell_size: Vector2i = $"/root/Node2D/GridMap".tile_set.tile_size

# This sprite will contain the LED on and off textures.
var led_sprite := Sprite2D.new()


func set_top_left(pos: Vector2i) -> void:
	super.set_top_left(pos)
	position = pos * pin_cell_size + pin_cell_size / 2


func load_cfg(cfg: String) -> void:
	_load(cfg)


func _ready() -> void:
	# The amount of space (in pin widths) the device takes up.
	device_size = Vector2i(5, len(pin_names) / 2)

	var pin_grid := $"/root/Node2D/Control/PinGrid"

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

	set_top_left(top_left)


func _process(delta: float) -> void:
	pass
