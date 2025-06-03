class_name UpgradeCard
extends MarginContainer

@onready var upgrade_name_label:Label = %upgrade_name
@onready var upgrade_image:TextureRect = %upgrade_image
@onready var upgrade_effect_label:Label = %upgrade_effect
@onready var upgrade_cost_label:Label = %upgrade_cost
@onready var upgrade_cost_image:TextureRect = %upgrade_cost_image
@onready var loja = $"../../.."
@export var possibilities_target :Dictionary[int,String]
@export var target_possibilities: Dictionary[String,Array]
var upgrade_name:String
var upgrade_image_path:String
var upgrade_effect:String
var upgrade_cost:int
var basic_cost:int
var card_is_choosen:String
var buff:int
var sub_prop:int
var upgrade_cost_image_path:String
var alma_comum = "res://UI/UI_images/Alma_Comum_UI.png"
var alma_incomum = "res://UI/UI_images/Alma_Zumbi_incomum.png"
var alma_rara = "res://UI/UI_images/Alma_zumbi_raro.png"
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
		card_is_choosen = card_affect[randi_range(0,card_affect.size()-1)]
		print(card_is_choosen)
		
		match card_is_choosen:
			"Vida_max":
				set_card_aumenta_vida_max(GameManager.vida_max_up)
			"Stamina_max":
				set_card_aumenta_stamina_max(GameManager.stamina_max_up)
			"Stamina_rege":
				set_card_aumenta_stamina_regen(GameManager.stamina_rege_up)
			"sword_damage":
				set_card_aumenta_sword_damage(GameManager.sword_damage_up)
			"Revolver":
				set_card_aumenta_revolver(GameManager.upgrade_revolver)
			"Metralhadora":
				set_card_aumenta_metralhadora(GameManager.upgrade_metralhadora)
			"Shotgun":
				set_card_aumenta_shotgun(GameManager.upgrade_shotgun)
			"Magnum":
				set_card_aumenta_algo(card_is_choosen)
			"Bazuca":
				set_card_aumenta_algo(card_is_choosen)
			_:
				print("Aumentou alguma outra coisa, talvez a ",card_is_choosen)

#Essa função adiciona os valores criados no objeto carta
func set_card():
	upgrade_name_label.text = upgrade_name
	upgrade_image.texture = load(upgrade_image_path)
	upgrade_effect_label.text = upgrade_effect
	upgrade_cost_label.text = "Custo: "+ str(upgrade_cost)
	upgrade_cost_image.texture = load(upgrade_cost_image_path)

####---------------------vvvvvv--------------------------####
#region determinar o tipo de texto e buff
#Essas funções servem para determinar o texto e o buff de cada carta.
func set_card_aumenta_algo(algo_up):
	upgrade_name = "Aumenta alguma coisa na " + card_is_choosen
	buff = 0
	upgrade_effect = "Isso vai fazer algo para a "+card_is_choosen+" só não sabemos o que ainda"
	basic_cost = randi_range(0,300000)
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_vida_max(vida_max_up):
	upgrade_name = "Aumento de vida máxima"
	buff = randi_range(5,10)
	upgrade_effect = "Aumenta a vida máxima do jogador em "+ str(buff)
	basic_cost = (80+2*vida_max_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_stamina_max(stamina_max_up):
	upgrade_name = "Aumento de Stamina Max"
	buff = randi_range(10,20)
	upgrade_effect = "Aumenta a Stamina máxima do jogador em "+ str(buff)
	basic_cost = (200+2*stamina_max_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_stamina_regen(stamina_rege_up):
	upgrade_name = "Aumento de Regeneração de stamina"
	buff = randi_range(1,5)
	upgrade_effect = "Aumenta a  regeneração de stamina do jogador em "+ str(buff)
	basic_cost = (200+2*stamina_rege_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_sword_damage(sword_damage_up):
	upgrade_name = "Aumento de dano da espada do jogador"
	buff = randi_range(1,5)
	upgrade_effect = "Aumenta o dano de ataque com espada do jogador em "+ str(buff)
	basic_cost = (200+2*sword_damage_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_revolver(upgrade_revolver):
	upgrade_image_path = "res://weapons/revolver/revolver_icon_2.png"
	sub_prop = randi_range(0,1)
	if sub_prop == 0:
		upgrade_name = "Aumento de munição do revólver"
		buff = randi_range(1,3)
		upgrade_effect = "Aumenta a munição máxima do revólver em " + str(buff)
		basic_cost = (200+2*upgrade_revolver[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_name = "Aumento de dano do revólver"
		buff = randi_range(2,10)
		upgrade_effect  = "Aumenta o dano do revólver em " + str(buff)
		basic_cost  = (200+2*upgrade_revolver[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
func set_card_aumenta_metralhadora(upgrade_metralhadora):
	upgrade_image_path = "res://weapons/machinegun/machinegun.png"
	sub_prop = randi_range(0,2)
	if sub_prop == 0:
		upgrade_name = "Aumento de munição da metralhadora"
		buff = randi_range(10,30)
		upgrade_effect = "Aumenta a munição máxima da metralhadora em " + str(buff)
		basic_cost = (20+2*upgrade_metralhadora[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_name = "Aumento de dano da metralhadora"
		buff = randi_range(1,3)
		upgrade_effect  = "Aumenta o dano da metralhadora em " + str(buff)
		basic_cost  = (20+2*upgrade_metralhadora[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 2:
		if GameManager.upgrade_metralhadora[2] <= 0: start_card() 
		upgrade_name = "Mira melhor"
		buff = randi_range(min(10,GameManager.upgrade_metralhadora[2]),min(50,GameManager.upgrade_metralhadora[2]))
		upgrade_effect = "Reduz o espalhamento das balas em " +str(buff)+"%"
		basic_cost = snapped(10/((upgrade_metralhadora[sub_prop]-(buff))*0.01+0.01),1) #func set_card_aumenta_algo(algo_up):
		print("Denominador: "+ str(((upgrade_metralhadora[sub_prop]-(buff))*0.01+0.01)))
		buff = -buff
		calcula_custo_almas(basic_cost)
		
func set_card_aumenta_shotgun(upgrade_shotgun):
	upgrade_image_path = "res://weapons/shotgun/shotgun_icon.png"
	sub_prop = randi_range(0,4)
	if sub_prop == 0:
		upgrade_name = "Aumento de munição da shotgun"
		buff = randi_range(1,4)
		upgrade_effect = "Aumenta a munição máxima da shotgun em " + str(buff)
		basic_cost = (200+2*upgrade_shotgun[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_name = "Aumento de dano da shotgun"
		buff = randi_range(5,10)
		upgrade_effect  = "Aumenta o dano da shotgun em " + str(buff)
		basic_cost  = (20+2*upgrade_shotgun[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 2:
		if GameManager.upgrade_shotgun[2] <= 0: start_card() 
		upgrade_name = "Mira melhor"
		buff = randi_range(min(10,GameManager.upgrade_shotgun[2]),min(50,GameManager.upgrade_shotgun[2]))
		upgrade_effect = "Reduz o espalhamento das balas em " +str(buff)+"%"
		basic_cost = snapped(10/((upgrade_shotgun[sub_prop]-(buff))*0.01+0.01),1) #func set_card_aumenta_algo(algo_up):
		#print("Denominador: "+ str(((upgrade_shotgun[sub_prop]-(buff))*0.01+0.01)))
		buff = -buff
		calcula_custo_almas(basic_cost)
	if sub_prop == 3:
		upgrade_name = "Alcance Maior"
		buff = randi_range(10,30)
		upgrade_effect = "Aumenta o alcance das balas em " +str(buff)+"%"
		basic_cost = buff*GameManager.upgrade_shotgun[sub_prop]/10
		calcula_custo_almas(basic_cost)
	if sub_prop == 4:
		upgrade_name = "Mais estilhaços!"
		buff = randi_range(1,3)
		upgrade_effect = "Aumenta a quantidade de estilhaços em " + str(buff)
		basic_cost = (200+2*upgrade_shotgun[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
#func set_card_aumenta_algo(algo_up):
	#TODO
#func set_card_aumenta_algo(algo_up):
	#TODO
#func set_card_aumenta_algo(algo_up):
	#TODO

#endregion

#Essa função serve para aplicar o efeito quando o botão for apertado.
func _on_button_pressed() -> void:
	if not have_souls(upgrade_cost_image_path): return
	match card_is_choosen:
			"Vida_max":
				GameManager.vida_max_up += buff
				print("Sua vida máxima agora é ",40+GameManager.vida_max_up)
			"Stamina_max":
				GameManager.stamina_max_up+=buff
				print("Sua Stamina máxima agora é ",100+GameManager.stamina_max_up)
			"Stamina_rege":
				GameManager.stamina_rege_up+=buff
			"sword_damage":
				GameManager.sword_damage_up+=buff
			"Revolver":
				GameManager.upgrade_revolver[sub_prop]+=buff
			"Metralhadora":
				GameManager.upgrade_metralhadora[sub_prop]+=buff
				print(GameManager.upgrade_metralhadora[sub_prop])
			"Shotgun":
				GameManager.upgrade_shotgun[sub_prop]+=buff
			"Magnum":
				set_card_aumenta_algo(card_is_choosen)
			"Bazuca":
				set_card_aumenta_algo(card_is_choosen)
			_:
				print("Aumentou alguma outra coisa, talvez a ",card_is_choosen)
	loja.reset_cards()
	loja.atualiza_almas()

#Essa função calcula os preços e adapta eles para a alma correspondente:
func calcula_custo_almas(custo_alma):
	if custo_alma < 999:
		upgrade_cost = custo_alma
		upgrade_cost_image_path = alma_comum
	elif custo_alma <99999:
		upgrade_cost = snapped(custo_alma/100,1)
		upgrade_cost_image_path = alma_incomum
	else:
		upgrade_cost = snapped(custo_alma/10000,1)
		upgrade_cost_image_path = alma_rara

#Essa função checa se o jogador tem a quantidade de almas suficientes.
func have_souls(soul_type):
	if soul_type == alma_comum:
		if GameManager.alma_comum > upgrade_cost:
			GameManager.alma_comum -= upgrade_cost
			print("Você agora tem ",GameManager.alma_comum," almas")
			return true
		else:
			print("VOCÊ NÃO TEM ALMA SUFICIENTE")
			loja.aviso_almas()
			return false
	elif soul_type == alma_incomum:
		if GameManager.alma_incomum > upgrade_cost:
			GameManager.alma_incomum -= upgrade_cost
			print("Você agora tem ",GameManager.alma_incomum," almas")
			return true
		else:
			print("VOCÊ NÃO TEM ALMA SUFICIENTE")
			loja.aviso_almas()
			return false
	elif soul_type == alma_rara:
		if GameManager.alma_rara > upgrade_cost:
			GameManager.alma_rara -= upgrade_cost
			print("Você agora tem ",GameManager.alma_rara," almas")
			return true
		else:
			print("VOCÊ NÃO TEM ALMA SUFICIENTE")
			loja.aviso_almas()
			return false
