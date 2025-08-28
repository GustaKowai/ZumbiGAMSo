extends CanvasLayer

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			GameManager.scene_to_load = "res://UI/menu.tscn"
			get_tree().change_scene_to_file("res://UI/loading.tscn")
			queue_free()
