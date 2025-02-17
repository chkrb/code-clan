extends ItemList

const CENTER = Vector2i(860, 540)

func _on_item_activated(index):
	const CIR_DEV = preload("res://scenes/circuit_device.tscn")
	var device = CIR_DEV.instantiate()
	device.position = CENTER
	get_tree().root.add_child(device)
	
	
