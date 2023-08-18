extends RigidBody3D

@onready var shape_cast = $shape_cast
@export var look_speed = 0.01
@export var jump_force = 500
@export var acceleration = 5000
@export var max_speed = 5
@export var target : NodePath

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


#move to target using navigation, unless target is null, 
#in which case do nothing
func _integrate_forces(state):
	pass

func is_on_floor():
	return shape_cast.is_colliding()

func max_speed_reached(state):
	return state.linear_velocity.length() >= max_speed or linear_velocity.length() <= -max_speed
