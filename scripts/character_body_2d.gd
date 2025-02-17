extends CharacterBody2D

@export var MOVE_LENGTH = 40
var moving = false


func _physics_process(_delta):
	if get_parent().placed:
		return
	var dir = Input.get_vector("left", "right", "up", "down")
	if dir and moving:
		return
	if !dir and moving:
		moving = false
	if dir:
		moving = true
	get_parent().position.x += dir.x * MOVE_LENGTH
	get_parent().position.y += dir.y * MOVE_LENGTH
