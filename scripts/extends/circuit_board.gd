extends Node2D

const SIG_LO = 0
const SIG_HI = ~0
const SIG_UNKNOWN = 1

# Temporary line shown when a pin is selected.
# This helps is showing how the wires will be connected.
@onready var temp_conn := Line2D.new()
@onready var temp_conn_owner_coords := Vector2i(-1, -1)

var conns: Array[WireConn] = []
var devs: Array[CircuitDevice] = []

func join(p1: Vector2i, p2: Vector2i) -> void:
	if p1 == p2:
		return
	var conn := WireConn.new()
	conn.p1 = p1
	conn.p2 = p2
	add_child(conn)
	conns.append(conn)


func _ready() -> void:
	temp_conn.name = "TempConn"
	temp_conn.default_color = Color(0, 0, 0, 0.25)
	temp_conn.width = 5
	temp_conn.visible = false
	temp_conn.begin_cap_mode = Line2D.LINE_CAP_ROUND
	temp_conn.end_cap_mode = Line2D.LINE_CAP_ROUND
	add_child(temp_conn)


func _process(delta: float) -> void:
	if temp_conn.visible:
		var mouse_pos := get_global_mouse_position()
		temp_conn.remove_point(1)
		temp_conn.add_point(mouse_pos, 1)

	## devices (ICs, LEDs, etc.) will accept inputs
	## devices (ICs, LEDs, etc.) will process

	# Clear all wire signals.
	for conn in conns:
		conn.sig = SIG_UNKNOWN

	## load device output to wires and propogate them
