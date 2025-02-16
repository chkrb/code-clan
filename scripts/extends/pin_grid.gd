extends GridContainer

# Apparent screen size: 1920x1080
# Pin cell size: Extracted from GridMap's TileSet
@onready var screen_size := DisplayServer.screen_get_size()
@onready var pin_cell_size: Vector2i = $"/root/Node2D/GridMap".tile_set.tile_size
@onready var pin_dims := screen_size / pin_cell_size


func _ready() -> void:
	columns = pin_dims.x
	# Initialize PinButton(s) in column-major format.
	for y in range(pin_dims.y):
		for x in range(pin_dims.x):
			var pin_button := PinButton.new()
			pin_button.set_coords(Vector2i(x, y))
			pin_button.custom_minimum_size = pin_cell_size
			add_child(pin_button)
