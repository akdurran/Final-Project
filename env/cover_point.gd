class_name  CoverPoint extends Marker3D

@export var occupied : bool
@export var num_hidden_from : int
@export var distance : float

func _ready():
	add_to_group("coverpoint")

func rank_self_cover(enemy_teams : Array[String], ally_teams : Array[String], caller: RigidBody3D):
	num_hidden_from = 0
	var allies : Array[Node]
	var enemies : Array[Node]
	if occupied == false:
		var tree := get_tree()
		for team_name in ally_teams:
			allies.append_array(tree.get_nodes_in_group(team_name))
		for team_name in enemy_teams:
			enemies.append_array(tree.get_nodes_in_group(team_name))
		var ally_rids : Array[RID]
		
		for ally in allies:
			if ally is CollisionObject3D:
				ally_rids.append(ally.get_rid())
		
		for enemy in enemies:
			var space_state := get_world_3d().direct_space_state
			var query := PhysicsRayQueryParameters3D.create(global_position, enemy.global_position)
			query.exclude = ally_rids
			var result = space_state.intersect_ray(query)
			if result and result.collider != enemy:
				num_hidden_from +=1
		distance = global_position.distance_to(caller.global_position)
