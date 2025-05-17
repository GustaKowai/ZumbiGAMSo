class_name GameOverUI
extends CanvasLayer

@onready var time_label = %TimeLabel
@onready var kills_label = %KillsLabel
@onready var texto_morte = %TextoMorte

@export var restart_delay = 1.5
var restart_cooldown: float

func _ready():
	time_label.text = GameManager.time_elapsed_string
	kills_label.text = str(GameManager.kills_count)
	texto_morte.text = GameManager.texto_morte
	
	restart_cooldown = restart_delay
	
func _process(delta):
	
	restart_cooldown -= delta
	#if restart_cooldown <= 0.0:
		#if Input.is_action_just_pressed("attack"):
			#restart_game()
		#if Input.is_action_just_pressed("pause"):
			#restart_game()
		
func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
	pass
	

func _on_menu_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://UI/menu.tscn")



func _on_tentar_novamente_pressed() -> void:
	if restart_cooldown <= 0.0:
		restart_game()
