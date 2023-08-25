extends Node3D

@onready var player := $player
@onready var nav := $NavigationRegion3D
var cover_point := preload("res://env/cover_point.tscn")

func _physics_process(delta):
	#get_tree().call_group("follower","update_target_location",player.global_transform.origin)
	pass

func _input(event):
	if event.is_action_pressed("move_allies_to"):
		get_tree().call_group("follower","update_target_location", player.global_position)

