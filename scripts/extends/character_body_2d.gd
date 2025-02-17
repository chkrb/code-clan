extends CharacterBody2D

var moving = false


func _physics_process(_delta):
	if get_parent().placed:
		return
	var dir := Input.get_vector("left", "right", "up", "down")
	if dir and moving:
		return
	if !dir and moving:
		moving = false
	if dir:
		moving = true
	
	var dev_top_left = get_parent().top_left
	dev_top_left += Vector2i(dir)
	get_parent().set_top_left(dev_top_left)
