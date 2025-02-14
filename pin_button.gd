class_name PinButton
extends CenterContainer

var coords = Vector2i(-1, -1)


func set_coords(c: Vector2i) -> void:
	self.coords = c
	self.name = "PinContainer" + str(c.x) + "x" + str(c.y)


func _ready() -> void:
	var button := Button.new()
	button.name = "PinButton" + str(self.coords.x) \
						+ "x" + str(self.coords.y)
	self.add_child(button)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
