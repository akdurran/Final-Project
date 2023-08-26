class_name Ally extends RigidBody3D

@onready var shape_cast = $shape_cast
@export var look_speed = 0.01
@export var jump_force = 500
@export var acceleration = 5000
@export var max_speed = 5
@export var target : Node3D
@onready var nav = $nav
@onready var currently_shooting := false
@onready var current_target = null

func _ready():
	#This line is causing a crash: Invalid get index 'position' on base:'Nil'
	#nav.set_target_position(target.position)
	pass

#move to target using navigation, unless target is null, 
#in which case do nothing
func _integrate_forces(state):
	if (nav.target_position) and (currently_shooting == false):
		var new_position = nav.get_next_path_position()
		var direction = (new_position - global_position).normalized() * acceleration
		if direction and !max_speed_reached(state):
			#used to be the below line, multiplying by acceleration caused random teleporting
			#state.apply_central_force(Vector3(direction.x * acceleration, 0, direction.z * acceleration))
			state.apply_central_force(Vector3(direction.x, 0, direction.z))

func is_on_floor():
	return shape_cast.is_colliding()

func max_speed_reached(state):
	return state.linear_velocity.length() >= max_speed or linear_velocity.length() <= -max_speed


func _on_nav_navigation_finished():
	pass
	#I noticed that this causes a crash, using nav.set_target_position(null) does not work either
	#nav.target_position = null


func update_target_location(target_location):
	print("T:", target_location)
	nav.set_target_position(target_location)
	
func toggle_shooting(enemy):
	if currently_shooting == true:
		if current_target != enemy:
			stop_shooting_at_enemy(current_target)
			toggle_shooting(enemy)
		else:
			stop_shooting_at_enemy(enemy)
	else:
		if current_target != null:
			stop_shooting_at_enemy(current_target)
		shoot_at_enemy(enemy)
	
func shoot_at_enemy(enemy):
	#Enemy is targeted using numpad, 
	#Shooting logic goes here, not implemented yet?
	currently_shooting = true
	print("starting to shoot at enemy:", enemy)
	current_target = enemy
	pass

func stop_shooting_at_enemy(enemy):
	#stop shooting logic, not implemented yet
	currently_shooting = false
	print("stopped shooting at enemy:", enemy)
	current_target = null
	pass
