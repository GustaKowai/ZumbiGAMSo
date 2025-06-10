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
	reset_game_status()
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_arcade_pressed() -> void:
	reset_game_status()
	GameManager.arcade = true
	get_tree().change_scene_to_file("res://Main.tscn")
	

func reset_game_status():
	GameManager.arcade = false
	GameManager.alma_comum = 0
	GameManager.alma_incomum = 0
	GameManager.alma_rara = 0
	GameManager.vida_max_up = 0
	GameManager.stamina_max_up = 0
	GameManager.stamina_rege_up = 0
	GameManager.sword_damage_up = 0
	GameManager.upgrade_revolver = [0,0,0,0] #[munição,dano,perfuração,bala curva]
	GameManager.upgrade_metralhadora = [0,0,100,100] #[munição,dano,spreed,velocidade de tiro]
	GameManager.upgrade_shotgun = [0,0,100,100,0] #[munição,dano,spread,alcance,quandidade de estilhaços]
	GameManager.upgrade_magnum = [0,0] #[munição,dano]
	GameManager.upgrade_bazuca = [0,0] #[munição,dano]
