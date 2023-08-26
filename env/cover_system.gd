class_name CoverSystem extends NavigationRegion3D

@export var cover_point := preload("res://env/cover_point.tscn")
@export var max_height := 7

func _input(event):
	if Input.is_action_just_pressed("generate"):
		calculate_cover()

func _ready():
	calculate_cover()

func  calculate_cover():
		var verts : PackedVector3Array = get_navigation_mesh().get_vertices()
		var points : PackedVector3Array = verts.duplicate()
		
		
		
		for point in points:
			if point.y <= max_height:
				var cover = cover_point.instantiate(PackedScene.GEN_EDIT_STATE_MAIN)
				cover.set_position(point)
				add_child(cover)
		pass
