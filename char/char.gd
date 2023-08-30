class_name Char extends RigidBody3D
@export var max_speed := 5
@export var paths : NodePath
var paths_node : MeshInstance3D

## Returns whether the character has reached max speed
func max_speed_reached(state : PhysicsDirectBodyState3D) -> bool:
	return state.linear_velocity.length() >= max_speed or state.linear_velocity.length() <= -max_speed

func _ready():
	var node := get_node(paths)
	if node is MeshInstance3D:
		paths_node = node

func draw_path(path_array: PackedVector3Array) -> void:
	if path_array.size() > 0:
		var im: ImmediateMesh = paths_node.mesh
		im.clear_surfaces()
		im.surface_begin(Mesh.PRIMITIVE_POINTS, null)
		im.surface_add_vertex(path_array[0])
		im.surface_add_vertex(path_array[path_array.size() - 1])
		im.surface_end()
		im.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, null)
		for current_vector in path_array:
			im.surface_add_vertex(current_vector)
		im.surface_end()
