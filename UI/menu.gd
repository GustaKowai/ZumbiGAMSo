extends Control


func _on_jogar_pressed() -> void:
	SaveLoad.load_data()
	GameManager.arcade = false
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_controles_pressed() -> void:
	pass


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_new_game_pressed() -> void:
	GameManager.reset_game_status()
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_arcade_pressed() -> void:
	GameManager.reset_game_status()
	GameManager.arcade = true
	get_tree().change_scene_to_file("res://Main.tscn")
	
