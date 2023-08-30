class_name Enemy extends AIChar

func _input(_event):
	if Input.is_action_just_pressed("reconsider"):
		reconsider_cover()


func _on_nav_navigation_finished():
	crouching = true;
