extends ItemList

const CENTER = Vector2i(860, 540)

const dev_list := ['7404', '7408', '7432', '7483', '7486', 'LED']

const CIR_DEV = preload("res://scenes/nodes/circuit_device.tscn")


func _on_item_activated(index):
	var device = CIR_DEV.instantiate()
	device.load_cfg(dev_list[index])
	get_tree().root.add_child(device)
