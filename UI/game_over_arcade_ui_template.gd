extends CanvasLayer
@onready var nomeJogador:TextEdit = %NomeJogador
@onready var testeLabel:Label = $VBoxContainer/HBoxContainer/RecordeMortes/Label5
@onready var recordeMortes = $VBoxContainer/HBoxContainer/RecordeMortes
var pontuacao:Array = GameManager.pontuacao

func _ready() -> void:
	escrever_recordes()

func _on_menu_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://UI/menu.tscn")


func _on_popup_panel_confirmed() -> void:
	testeLabel.text = nomeJogador.get_text()

func escrever_recordes():
	for player in pontuacao:
		var name_label = Label.new()
		name_label.text = player[0]+" "+str(player[1])+" Zumbis mortos!"
		recordeMortes.add_child(name_label)
