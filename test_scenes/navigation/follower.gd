extends RigidBody3D

@onready var nav_agent = $NavigationAgent3D
@export var acceleration := 5000
@export var max_speed := 5
@export var max_range := 1000

func _integrate_forces(state):
	var new_position = nav_agent.get_next_path_position()
	var direction = (new_position - global_position).normalized() * acceleration
	if not max_speed_reached(state):
		state.apply_central_force(Vector3(direction.x, 0, direction.z))
	

func update_target_location(target_location):
	nav_agent.set_target_position(target_location)

func max_speed_reached(state : PhysicsDirectBodyState3D) -> bool:
	return state.linear_velocity.length() >= max_speed or state.linear_velocity.length() <= -max_speed
