extends GridContainer

# Apparent screen size: 1920x1080
# Size of each container: 60x60 (GCD of 1920, 1080)
# Therefore, number of pins: 32x18
var pin_dims := Vector2i(32, 18)
var pin_widgets := []

func _ready() -> void:
	for y in range(pin_dims.y):
		for x in range(pin_dims.x):
			var pin_button := PinButton.new()
			pin_button.set_coords(Vector2i(x, y))
			pin_button.custom_minimum_size = Vector2i(60, 60)
			add_child(pin_button)
