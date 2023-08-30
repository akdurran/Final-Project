class_name Ally extends AIChar


@export var look_speed = 0.01
@export var jump_force = 500


@export var target : Node3D

@onready var currently_shooting := false
@onready var current_target = null

func _on_nav_navigation_finished():
	crouching = true


func update_target_location(target_location):
	crouching = false
	print("T:", target_location)
	nav.set_target_position(target_location)
	

