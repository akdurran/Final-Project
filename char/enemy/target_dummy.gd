class_name TargetDummy extends RigidBody3D
@onready var collider = $collider
@onready var capsule = $capsule
@onready var nav = $nav 
@export var crouching = false
@export var max_speed = 5
@export var acceleration = 5000
var cover_point : CoverPoint

func _physics_process(_delta):
	handle_crouch()

func _input(_event):
	if Input.is_action_just_pressed("reconsider"):
		reconsider_cover()

func _integrate_forces(state):
	var new_position = nav.get_next_path_position()
	var direction = (new_position - global_position).normalized() * acceleration
	if not max_speed_reached(state):
		state.apply_central_force(Vector3(direction.x, 0, direction.z))
	

func reconsider_cover():
	crouching = false
	if cover_point:
		cover_point.occupied = false
	cover_point = find_cover("player_team", "enemy_team")
	cover_point.occupied = true
	nav.set_target_position(cover_point.global_position)
	
	

func handle_crouch():
	if crouching: 
		if collider.get_scale().y > 0.5 or capsule.get_scale().y > 0.5:
			collider.scale.y = lerp(collider.scale.y, 0.5, 0.1)
			capsule.scale.y = lerp(capsule.scale.y, 0.5, 0.1)
	if not crouching:
		if collider.get_scale().y < 1 or capsule.get_scale().y < 1:
			collider.scale.y = lerp(collider.scale.y, 1.0, 0.1)
			capsule.scale.y = lerp(capsule.scale.y, 1.0, 0.1)

func find_cover(enemy_team : String, ally_team : String) -> CoverPoint:
	var hidden_points : Array[CoverPoint]
	
	for point in get_tree().get_nodes_in_group("coverpoint"):
		if point is CoverPoint:
			point.rank_self(enemy_team, ally_team, self)
			hidden_points.append(point)
	hidden_points.sort_custom(cover_quality)
	return hidden_points[0]

func cover_quality(a : CoverPoint, b : CoverPoint) -> bool:
	return (a.num_hidden_from/a.distance) > (b.num_hidden_from/b.distance)

func max_speed_reached(state : PhysicsDirectBodyState3D) -> bool:
	return state.linear_velocity.length() >= max_speed or state.linear_velocity.length() <= -max_speed


func _on_nav_navigation_finished():
	crouching = true;
	nav.set_target_position(global_position)
