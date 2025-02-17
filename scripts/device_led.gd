class_name DeviceLED
extends CircuitDevice

@onready var pin_cell_size: Vector2i = $"/root/Node2D/GridMap".tile_set.tile_size

# This sprite will contain the LED on and off textures.
var led_sprite := Sprite2D.new()


func set_top_left(pos: Vector2i) -> void:
	super.set_top_left(pos)
	position = pos * pin_cell_size + pin_cell_size / 2


func _ready() -> void:
	# The amount of space (in pin widths) the device takes up.
	device_size = Vector2i(2, 2)
	_load("LED")

	var pin_grid := $"/root/Node2D/Control/PinGrid"
	led_sprite.texture = ImageTexture.create_from_image(Image.load_from_file(
		"res://images/devices/led_sprite.png"
	))
	led_sprite.hframes = 2
	var frame_size := \
		led_sprite.texture.get_size() / Vector2(led_sprite.hframes, led_sprite.vframes)
	led_sprite.scale = Vector2(device_size * pin_cell_size) / frame_size
	led_sprite.centered = false
	set_top_left(top_left)
	add_child(led_sprite)

func _process(delta: float) -> void:
	led_sprite.frame = int(_working())
