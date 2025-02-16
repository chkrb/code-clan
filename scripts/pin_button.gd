class_name PinButton
extends CenterContainer

var coords = Vector2i(-1, -1)


func set_coords(c: Vector2i) -> void:
	self.coords = c
	self.name = "PinContainer" + str(c.x) + "x" + str(c.y)


func _ready() -> void:
	var button := Button.new()
	button.name = "PinButton" + str(self.coords.x) \
						+ "x" + str(self.coords.y)
	button.pressed.connect(_button_pressed)
	add_child(button)


func _button_pressed():
	var wire_lines_node := $"/root/Node2D/CircuitBoard"
	var pin_grid_node := $"/root/Node2D/Control/PinGrid"
	# Toggle visibility.
	if not wire_lines_node.temp_conn.visible:
		wire_lines_node.temp_conn_owner_coords = coords
		wire_lines_node.temp_conn.clear_points()
		wire_lines_node.temp_conn.add_point(
			coords
			* pin_grid_node.pin_cell_size
			+ pin_grid_node.pin_cell_size / 2
		)
		wire_lines_node.temp_conn.visible = true
	else:
		wire_lines_node.join(wire_lines_node.temp_conn_owner_coords, coords)
		wire_lines_node.temp_conn.visible = false
