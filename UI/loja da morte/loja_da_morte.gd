extends Control
@onready var card_container = %CardContainer
@onready var alma_comum = $VBoxContainer/HBoxContainer/alma_comum_label
@onready var alma_incomum = $VBoxContainer/HBoxContainer/alma_incomum_label
@onready var alma_rara = $VBoxContainer/HBoxContainer/alma_rara_label
@onready var aviso_almas_label = $VBoxContainer/MarginContainer2/aviso_almas

@export var cartas:PackedScene

func _ready() -> void:
	set_cards()
	#GameManager.alma_comum += 10000
	aviso_almas_label.modulate.a = 0
	set_aviso()
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
func set_aviso():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(aviso_almas_label,"modulate",Color.WHITE,0.4)
	
func aviso_almas():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(aviso_almas_label,"modulate",Color.RED,0.4)
	tween.tween_property(aviso_almas_label,"modulate",Color.TRANSPARENT,1.5)
	aviso_almas_label.text = "Você não possui almas suficiente."
	
func _on_button_pressed() -> void:
	if GameManager.alma_comum < 5:
		aviso_almas()
		return
	GameManager.alma_comum-=5
	atualiza_almas()
	reset_cards()


func _on_voltar_pro_jogo_pressed() -> void:
	SaveLoad.save()
	GameManager.scene_to_load = "res://Main.tscn"
	get_tree().change_scene_to_file("res://UI/loading.tscn")


func _on_button_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(aviso_almas_label,"modulate",Color.WHITE,0.4)
	tween.tween_property(aviso_almas_label,"modulate",Color.TRANSPARENT,1.5)
	aviso_almas_label.text = "Atualizar as cartas custa 5 almas comuns."
