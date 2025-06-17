extends CanvasLayer
@onready var nomeJogador:TextEdit = %NomeJogador
@onready var testeLabel:Label = $VBoxContainer/HBoxContainer/RecordeMortes/Label5
@onready var recordeMortes = $VBoxContainer/HBoxContainer/RecordeMortes
@onready var recordeTempo = $VBoxContainer/HBoxContainer/RecordeTempo
@onready var PopupRecord:AcceptDialog = $PopupRecorde
var pontuacao_mortes:Array
var pontuacao_tempo:Array
var recorde_mortes:bool = false
var recorde_tempo:bool = false

func _ready() -> void:
	SaveLoad.load_arcade()
	pontuacao_mortes = GameManager.pontuacao_mortes
	pontuacao_tempo = GameManager.pontuacao_tempo
	check_for_record()
	if recorde_mortes or recorde_tempo:
		print(recorde_mortes or recorde_tempo)
		PopupRecord.visible = true
	escrever_recordes()

func _on_menu_pressed() -> void:
	GameManager.reset()
	get_tree().change_scene_to_file("res://UI/menu.tscn")


func _on_popup_panel_confirmed() -> void:
	if recorde_mortes:
		var pontuacao_player:Array
		pontuacao_player.append(nomeJogador.get_text())
		pontuacao_player.append(GameManager.kills_count)
		pontuacao_mortes.append(pontuacao_player)
		pontuacao_mortes.sort_custom(sort_pontuacao)
		if pontuacao_mortes.size() > 10:
			pontuacao_mortes.pop_back()
	if recorde_tempo:
		var pontuacao_player:Array
		pontuacao_player.append(nomeJogador.get_text())
		pontuacao_player.append(GameManager.time_elapsed)
		pontuacao_player.append(GameManager.time_elapsed_string)
		pontuacao_tempo.append(pontuacao_player)
		pontuacao_tempo.sort_custom(sort_pontuacao)
		if pontuacao_tempo.size() > 10:
			pontuacao_tempo.pop_back()
	GameManager.pontuacao_mortes = pontuacao_mortes
	GameManager.pontuacao_tempo = pontuacao_tempo
	SaveLoad.save_arcade()
	escrever_recordes()
	
	
func escrever_recordes():
	##Escreve o recorde de mortes do zumbi
	for n in recordeMortes.get_children():
		recordeMortes.remove_child(n)
		n.queue_free()
	for player in pontuacao_mortes:
		var name_label = Label.new()
		name_label.text = player[0]+" "+str(player[1])+" Zumbis mortos!"
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		recordeMortes.add_child(name_label)
	##Escreve o recorde de tempo	
	for n in recordeTempo.get_children():
		recordeTempo.remove_child(n)
		n.queue_free()
	for player in pontuacao_tempo:
		var name_label = Label.new()
		name_label.text = player[0]+" "+player[2]+" tempo sobrevivido"
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		recordeTempo.add_child(name_label)

func check_for_record():
	if pontuacao_mortes.size() <10:
		recorde_mortes = true
	else:
		var menor_pontuacao:Array = pontuacao_mortes[9]
		if GameManager.kills_count > menor_pontuacao[1]:
			recorde_mortes = true
	if pontuacao_tempo.size() <10:
		recorde_tempo = true
	else:
		var menor_pontuacao:Array = pontuacao_tempo[9]
		if GameManager.kills_count > menor_pontuacao[1]:
			recorde_mortes = true

func sort_pontuacao(a,b):
	if a[1] > b[1]:
		return true
	return false
