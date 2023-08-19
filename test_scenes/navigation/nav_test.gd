extends Node3D

@onready var player = $player

func _physics_process(delta):
	get_tree().call_group("follower","update_target_location",player.global_transform.origin)
