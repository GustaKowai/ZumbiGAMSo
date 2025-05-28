class_name UpgradeCard
extends MarginContainer

@onready var upgrade_name_label = $PanelContainer/VBoxContainer/upgrade_name
@onready var upgrade_image = $PanelContainer/VBoxContainer/MarginContainer/upgrade_image
@onready var upgrade_effect_label = $PanelContainer/VBoxContainer/upgrade_effect
@onready var upgrade_cost_label = $PanelContainer/VBoxContainer/upgrade_cost
@export var possibilities_target :Dictionary[int,String]
@export var target_possibilities: Dictionary[String,Array]
var upgrade_name:String
var upgrade_image_path:String
var upgrade_effect:String
var upgrade_cost:int

func _ready() -> void:
	set_card()

#Essa função inicializa o card, sorteando o tipo de carta que será.
func start_card() -> void:
	for i in range(1):
		var target = randi_range(0,possibilities_target.size()-1)
		print(possibilities_target.size())
		var target_choosen = possibilities_target[target] 
		print(target_choosen)
		var card_affect = target_possibilities[target_choosen]
		var card_is_choosen = card_affect[randi_range(0,card_affect.size()-1)]
		print(card_is_choosen)
		card_is_choosen = "Vida_max"
		
		match card_is_choosen:
			"Vida_max":
				set_card_aumenta_vida_max(GameManager.vida_max_up)
			"Stamina_max":
				set_card_aumenta_stamina_max()
			_:
				print("Aumentou alguma outra coisa, talvez a ",card_is_choosen)

#Essa função adiciona os valores criados no objeto carta
func set_card():
	upgrade_name_label.text = upgrade_name
	upgrade_image.texture = load(upgrade_image_path)
	upgrade_effect_label.text = upgrade_effect
	upgrade_cost_label.text = "Custo: "+ str(upgrade_cost)

#Essas funções servem para determinar o texto e o buff de cada carta.
func set_card_aumenta_vida_max(vida_max_up):
	upgrade_name = "Aumento de vida máxima"
	var buff = randi_range(10,20)
	upgrade_effect = "Aumenta a vida máximo do jogador em "+ str(buff)
	upgrade_cost = (200+2*vida_max_up+buff)*(buff+1)/2
	
func set_card_aumenta_stamina_max():
	pass
