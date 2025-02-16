class_name WireConn
extends Node2D

# The two pin locations of connection endpoints.
var p1 = Vector2i(-1, -1)
var p2 = Vector2i(-1, -1)

var line = Line2D.new()
var epoint1 = Line2D.new()
var epoint2 = Line2D.new()


func _ready() -> void:
	var pin_grid := $"/root/Node2D/Control/PinGrid"
	var p1_global = p1 * pin_grid.pin_cell_size + pin_grid.pin_cell_size / 2
	var p2_global = p2 * pin_grid.pin_cell_size + pin_grid.pin_cell_size / 2
	# Connecting line.
	line.default_color = Color(0, 0, 0, 0.5)
	line.width = 5
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.add_point(p1_global)
	line.add_point(p2_global)
	add_child(line)
	# Connection endpoint 1.
	epoint1.default_color = Color(0, 0, 0, 0.5)
	epoint1.width = 15
	epoint1.begin_cap_mode = Line2D.LINE_CAP_ROUND
	epoint1.end_cap_mode = Line2D.LINE_CAP_ROUND
	epoint1.add_point(p1_global - Vector2i(1, 0))
	epoint1.add_point(p1_global + Vector2i(1, 0))
	add_child(epoint1)
	# Connection endpoint 2.
	epoint2.default_color = Color(0, 0, 0, 0.5)
	epoint2.width = 15
	epoint2.begin_cap_mode = Line2D.LINE_CAP_ROUND
	epoint2.end_cap_mode = Line2D.LINE_CAP_ROUND
	epoint2.add_point(p2_global - Vector2i(1, 0))
	epoint2.add_point(p2_global + Vector2i(1, 0))
	add_child(epoint2)

	var p1_pin = get_node(
		"/root/Node2D/Control/PinGrid/PinContainer"
		+ str(p1.x) + "x" + str(p1.y)
	)
	var p2_pin = get_node(
		"/root/Node2D/Control/PinGrid/PinContainer"
		+ str(p2.x) + "x" + str(p2.y)
	)
	p1_pin.pin_wires.append(self)
	p2_pin.pin_wires.append(self)
