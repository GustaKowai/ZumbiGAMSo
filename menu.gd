extends Control


func _on_jogar_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_controles_pressed() -> void:
	pass # Replace with function body.


func _on_sair_pressed() -> void:
	get_tree().quit()
