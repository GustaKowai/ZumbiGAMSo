extends Control
@onready var card_container = $VBoxContainer/CardContainer
@onready var alma_comum = $VBoxContainer/HBoxContainer/alma_comum_label
@onready var alma_incomum = $VBoxContainer/HBoxContainer/alma_incomum_label
@onready var alma_rara = $VBoxContainer/HBoxContainer/alma_rara_label


@export var cartas:PackedScene

func _ready() -> void:
	set_cards()
	GameManager.alma_comum = 10000
	atualiza_almas()

func atualiza_almas():
	alma_comum.text = str(GameManager.alma_comum)
	alma_incomum.text = str(GameManager.alma_incomum)
	alma_rara.text = str(GameManager.alma_rara)
func set_cards():
	for i in range(4):
		var card = cartas.instantiate()
		card.start_card()
		card_container.add_child(card)

func reset_cards():
	for n in card_container.get_children():
		card_container.remove_child(n)
		n.queue_free()
	set_cards()


func _on_button_pressed() -> void:
	if GameManager.alma_comum < 100: return
	GameManager.alma_comum-=100
	atualiza_almas()
	reset_cards()


func _on_voltar_pro_jogo_pressed() -> void:
	get_tree().change_scene_to_file("res://Main.tscn")
