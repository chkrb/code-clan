class_name DeviceIC
extends CircuitDevice


func _ready() -> void:
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
	
	var label := Label.new()
	label.text = cfg_name
	label.add_theme_font_size_override("font_size", 32)
	rect.add_child(label)
	
	add_child(rect)

	set_top_left(top_left)
