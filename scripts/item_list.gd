extends ItemList

var dev_files: PackedStringArray = []

# Load the base device class from scene.
const CIR_DEV = preload("res://scenes/nodes/circuit_device.tscn")


func _find_dev_files(path):
	var dir = DirAccess.open(path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			dev_files.append(file_name.trim_suffix(".ini"))
		file_name = dir.get_next()


func _ready() -> void:
	if not dev_files:
		_find_dev_files("res://devices/")
		dev_files.sort()

	for dev_cfg in dev_files:
		add_item(dev_cfg)


func _on_item_activated(index) -> void:
	# If there's any non-placed node, don't place a new node.
	for child in $"/root/Node2D/CircuitBoard".get_children():
		if child is CircuitDevice and not child.placed:
			return
	
	var device = CIR_DEV.instantiate()
	device.load_cfg(dev_files[index])
	$"/root/Node2D/CircuitBoard".add_child(device)
