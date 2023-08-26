extends Node3D

@onready var player := $player
@onready var nav := $NavigationRegion3D
var cover_point := preload("res://env/cover_point.tscn")
#var LineDrawer = preload("res://test_scenes/navigation/DrawLine3D.gd").new()

var currently_selected_ally := 0
var currently_selected_enemy = null


func _physics_process(_delta):
	#get_tree().call_group("follower","update_target_location",player.global_transform.origin)
	pass

func _input(event):
	if event.is_action_pressed("move_allies_to_self"):
		get_tree().call_group("follower","update_target_location", player.global_position)
	
	if event.is_action_pressed("move_allies_to_view_point"):
		var results = get_position_from_raycast()
		if results != null:
			get_tree().get_nodes_in_group("follower")[currently_selected_ally].update_target_location(results)
			#print(get_tree().get_nodes_in_group("follower"))
		#print(results)
	if event.is_action_pressed("ally_fire_at_targetted_enemy"):
		if currently_selected_enemy == null:
			print("No target selected! use numpad 4 or 5 to select target.")
			return
		
		var selected_ally = get_tree().get_nodes_in_group("follower")[currently_selected_ally]
		var selected_enemy = get_tree().get_nodes_in_group("enemy_team")[currently_selected_enemy]
		selected_ally.toggle_shooting(selected_enemy)
		
	if event.is_action_pressed("select_ally_0"):
		currently_selected_ally = 0
	
	if event.is_action_pressed("select_ally_1"):
		currently_selected_ally = 1
		
	if event.is_action_pressed("select_enemy_0"):
		#setting back to null if you attempt to select the enemy again
		if currently_selected_enemy == 0:
			currently_selected_enemy = null
			print("No enemy targetted")
		else:
			currently_selected_enemy = 0
			print("Targetted enemy 0")
	
	if event.is_action_pressed("select_enemy_1"):
		if currently_selected_enemy == 1:
			currently_selected_enemy = null
			print("No enemy targetted")
		else:
			currently_selected_enemy = 1
			print("Targetted enemy 1")


func get_position_from_raycast():
	var player_raycast = get_tree().get_nodes_in_group("player_raycast")[0]
	var _exclusion_node = $NavigationRegion3D/World/Full_map_CSGCombiner3D
	var collision_point = player_raycast.get_collision_point()
	
	player_raycast.force_raycast_update()

	var collider = player_raycast.get_collider()
	print(collider.get_name())
	if collider.get_name() == "follower":
		return null
	
	
	return collision_point
