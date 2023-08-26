class_name  CoverPoint extends Marker3D

@export var occupied : bool
@export var num_hidden_from : int
@export var distance : float

func _ready():
	add_to_group("coverpoint")

func rank_self(enemy_team : String, ally_team : String, caller: RigidBody3D):
	num_hidden_from = 0
	if occupied == false:
		var tree := get_tree()
		var allies := tree.get_nodes_in_group(ally_team)
		var ally_rids : Array[RID]
		
		for ally in allies:
			if ally is CollisionObject3D:
				ally_rids.append(ally.get_rid())
		
		for enemy in tree.get_nodes_in_group(enemy_team):
			var space_state := get_world_3d().direct_space_state
			var query := PhysicsRayQueryParameters3D.create(global_position, enemy.global_position)
			query.exclude = ally_rids
			var result = space_state.intersect_ray(query)
			if result:
				print(result.collider)
			if result and result.collider != enemy:
				num_hidden_from +=1
		distance = global_position.distance_to(caller.global_position)
