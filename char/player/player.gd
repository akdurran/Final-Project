extends RigidBody3D

@onready var shape_cast = $shape_cast
@onready var camera = $rotation_helper/camera
@onready var rotation_helper = $rotation_helper
@export var look_speed = 0.01
@export var jump_force = 500
@export var acceleration = 5000
@export var max_speed = 5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		var rotx = -event.relative.x
		var roty = -event.relative.y
		
		rotation_helper.rotate_y(rotx*look_speed)
		camera.rotation.x = clamp(camera.rotation.x + roty * look_speed, deg_to_rad(-90), deg_to_rad(90))
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _integrate_forces(state):
	if Input.is_action_just_pressed("jump")  and is_on_floor():
		state.apply_central_impulse(Vector3(0, jump_force, 0))

	var input_dir
	if is_on_floor():
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	else:
		input_dir = Vector2(0,0)

	var direction = (rotation_helper.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and !max_speed_reached(state):
		state.apply_central_force(Vector3(direction.x * acceleration, 0, direction.z * acceleration))

func is_on_floor():
	return shape_cast.is_colliding()

func max_speed_reached(state):
	return state.linear_velocity.length() >= max_speed or linear_velocity.length() <= -max_speed
