extends TileMapLayer

@onready var screen_size = get_viewport_rect().size


func _ready() -> void:
	# Calculate the individual tile size.
	var tile_dims = Vector2(
		screen_size.x / tile_set.tile_size.x,
		screen_size.y / tile_set.tile_size.y,
	)
	
	var tile_source = tile_set.get_source_id(0)
	
	for x in range(tile_dims.x):
		for y in range(tile_dims.y):
			set_cell(Vector2i(x, y), tile_source, Vector2i(0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
