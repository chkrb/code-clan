extends GridContainer

const SIG_LO = 0
const SIG_HI = ~0
const SIG_UNKNOWN = 1

# Apparent screen size: 1920x1080
# Pin cell size: Extracted from GridMap's TileSet
@onready var screen_size := DisplayServer.screen_get_size()
@onready var pin_cell_size := Vector2i(40, 40)


func _power_rail_line(color: Color, y: int) -> void:
	var line := Line2D.new()
	line.default_color = color
	line.width = 5
	line.add_point(Vector2i(0, y))
	line.add_point(Vector2i(screen_size.x, y))
	add_child(line)

func _ready() -> void:
	var pin_dims := screen_size / pin_cell_size
	
	# Line highlighting the power rails.
	_power_rail_line(Color(1, 0, 0, 0.5), pin_cell_size.y * 0.5)
	_power_rail_line(Color(0, 0, 1, 0.5), pin_cell_size.y * 1.5)
	_power_rail_line(Color(1, 0, 0, 0.5), screen_size.y - pin_cell_size.y * 1.5)
	_power_rail_line(Color(0, 0, 1, 0.5), screen_size.y - pin_cell_size.y * 0.5)

	columns = pin_dims.x
	# Initialize PinButton(s) in column-major format.
	for y in range(pin_dims.y):
		for x in range(pin_dims.x):
			var pin := Pin.new()
			pin.set_coords(Vector2i(x, y))
			pin.custom_minimum_size = pin_cell_size
			# VCC power rails.
			if (y == 0 or y == pin_dims.y - 2):
				pin.sig = SIG_HI
				pin.sig_const = true
			# GND power rails.
			elif (y == 1 or y == pin_dims.y - 1):
				pin.sig = SIG_LO
				pin.sig_const = true
			add_child(pin)
