extends ItemList

const CENTER = Vector2i(860, 540)

func _on_item_activated(index):
	var icon = Sprite2D.new()
	icon.texture = self.get_item_icon(index)
	icon.global_position = CENTER
	get_tree().root.add_child(icon)
