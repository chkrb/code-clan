extends CharacterBody2D

@export var SPEED = 1600
var moving = false


func _physics_process(_delta):
	if get_parent().placed:
		return
	var dir = Input.get_vector("left", "right", "up", "down")
	if dir and moving:
		return
	if !dir and moving:
		moving = false
	velocity = dir * SPEED
	move_and_slide()
	if dir:
		moving = true
		print(get_parent().position - position)
