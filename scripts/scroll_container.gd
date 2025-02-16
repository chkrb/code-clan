extends ScrollContainer

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.x <= 0:
		self.show()
	elif mouse_pos.x > self.size.x:
		self.hide()
