extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_jogar_pressed() -> void:
	SaveLoad.load_data()
	GameManager.arcade = false
	GameManager.scene_to_load = "res://Main.tscn"
	play_animations()


func _on_controles_pressed() -> void:
	pass


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_new_game_pressed() -> void:
	GameManager.reset_game_status()
	GameManager.scene_to_load = "res://Main.tscn"
	play_animations()


func _on_arcade_pressed() -> void:
	GameManager.reset_game_status()
	GameManager.arcade = true
	GameManager.scene_to_load = "res://Main.tscn"
	play_animations()
	

func play_animations():
	animation_player.play("jaula_formando")
	animation_player.queue("alma_presa")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "alma_presa":
		get_tree().change_scene_to_file("res://UI/loading.tscn")
