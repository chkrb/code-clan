class_name Pin
extends CenterContainer

const SIG_LO = 0
const SIG_HI = ~0
const SIG_UNKNOWN = 1

# TODO: get size from %PinGrid.pin_cell_size
const pin_cell_size := Vector2i(40, 40)

var coords := Vector2i(-1, -1)
var sig := SIG_UNKNOWN
var sig_const := false
var sig_set := false

var pin_wires: Array[Wire] = []


func set_coords(c: Vector2i) -> void:
	coords = c
	name = "PinContainer" + str(c.x) + "x" + str(c.y)


func set_sig(new_sig: int) -> void:
	if sig_set or new_sig not in [SIG_HI, SIG_LO]:
		return

	sig_set = true
	if not sig_const:
		sig = new_sig

	# Propagate the signal to other connected pins via wires.
	for wire in pin_wires:
		var p1_pin = get_node(
			"/root/Node2D/Control/PinGrid/PinContainer"
			+ str(wire.p1.x) + "x" + str(wire.p1.y)
		)
		var p2_pin = get_node(
			"/root/Node2D/Control/PinGrid/PinContainer"
			+ str(wire.p2.x) + "x" + str(wire.p2.y)
		)
		p1_pin.set_sig(sig)
		p2_pin.set_sig(sig)


func _ready() -> void:
	var button := Button.new()
	button.name = \
		"PinButton" + str(self.coords.x) + "x" + str(self.coords.y)
	button.tooltip_text = \
		"(" + str(self.coords.x) + ", " + str(self.coords.y) + ")"
	button.pressed.connect(_button_pressed)
	add_child(button)


func _button_pressed():
	var circuit_board := $"/root/Node2D/CircuitBoard"
	# Toggle visibility.
	if not circuit_board.temp_conn.visible:
		circuit_board.temp_conn_owner_coords = coords
		circuit_board.temp_conn.clear_points()
		circuit_board.temp_conn.add_point(coords * pin_cell_size + pin_cell_size / 2)
		circuit_board.temp_conn.visible = true
	else:
		circuit_board.join(circuit_board.temp_conn_owner_coords, coords)
		circuit_board.temp_conn.visible = false
