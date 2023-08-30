class_name Player extends Char
## A physics based player character

## A shape cast node to use for floor detection
@onready var shape_cast := $shape_cast
@onready var camera := $rotation_helper/camera
@onready var rotation_helper := $rotation_helper
@onready var raycast := $"rotation_helper/Vision RayCast3D"
@onready var info := $hud/info
@export var look_speed := 0.01
@export var jump_force := 500
@export var acceleration := 5000
@export var max_range := 1000

#func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event : InputEvent):
	if event is InputEventMouseMotion:
		var rotx : float = -event.relative.x
		var roty : float = -event.relative.y
		var new_x_rotation = clamp(camera.rotation.x + roty * look_speed, deg_to_rad(-90), deg_to_rad(90))
		
		rotation_helper.rotate_y(rotx*look_speed)
		
		camera.rotation.x = new_x_rotation
		raycast.rotation.x = new_x_rotation
	
	if event is InputEventKey or event is InputEventJoypadButton:
		sleeping = false
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()

func _integrate_forces(state : PhysicsDirectBodyState3D):
	if Input.is_action_just_pressed("jump")  and is_on_floor():
		state.apply_central_impulse(Vector3(0, jump_force, 0))

	var input_dir : Vector2
	if is_on_floor():
		input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	else:
		input_dir = Vector2(0,0)

	var direction : Vector3 = (rotation_helper.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction and !max_speed_reached(state):
		state.apply_central_force(Vector3(direction.x * acceleration, 0, direction.z * acceleration))

## Returns a boolean representing whether the character is on floor
func is_on_floor() -> bool:
	return shape_cast.is_colliding()

