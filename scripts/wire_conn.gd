class_name WireConn
extends Node2D

const SIG_LO := 0
const SIG_HI := ~0
const SIG_UNKNOWN := 1

# The two pin locations of connection endpoints.
var p1 = Vector2i(-1, -1)
var p2 = Vector2i(-1, -1)

var line = Line2D.new()
var epoint1 = Line2D.new()
var epoint2 = Line2D.new()

# The current logic level held by the wire.
@onready var sig: int = $"/root/Node2D/CircuitBoard".SIG_UNKNOWN


func _ready() -> void:
	var pin_grid_node := $"/root/Node2D/Control/PinGrid"
	var p1_global = p1 * pin_grid_node.pin_cell_size + pin_grid_node.pin_cell_size / 2
	var p2_global = p2 * pin_grid_node.pin_cell_size + pin_grid_node.pin_cell_size / 2
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


func _process(delta: float) -> void:
	pass
