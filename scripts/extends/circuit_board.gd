extends Node2D

const SIG_LO = 0
const SIG_HI = ~0
const SIG_UNKNOWN = 1

# Temporary line shown when a pin is selected.
# This helps is showing how the wires will be connected.
@onready var temp_conn := Line2D.new()
@onready var temp_conn_owner_coords := Vector2i(-1, -1)

var conns: Array[Wire] = []
var devs: Array[CircuitDevice] = []


func join(p1: Vector2i, p2: Vector2i) -> void:
	if p1 == p2:
		return
	var conn := Wire.new()
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

	# Clear signal set flag of all pins.
	for pin in $"/root/Node2D/Control/PinGrid".get_children():
		if pin is Pin:
			pin.sig_set = false

	# Devices retrieve pin signals as inputs.
	for dev in get_children():
		if dev is CircuitDevice:
			dev.pin_inputs()

	# Devices process pin inputs to generate outputs.
	for dev in get_children():
		if dev is CircuitDevice:
			dev.pin_process()

	# Device outputs are transferred to the pin they're connected to.
	for dev in get_children():
		if dev is CircuitDevice:
			dev.pin_outputs()

	# Propagate pin signals through wires.
	for pin in $"/root/Node2D/Control/PinGrid".get_children():
		if pin is Pin:
			pin.set_sig(pin.sig)


func _input(event):
	if event is not InputEventMouseButton:
		return
	if not temp_conn.visible:
		return
	if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
		temp_conn.hide()
