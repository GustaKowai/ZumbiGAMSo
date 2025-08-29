class_name UpgradeCard
extends MarginContainer

@onready var upgrade_name_label:Label = %upgrade_name
@onready var upgrade_image:TextureRect = %upgrade_image
@onready var upgrade_effect_label:Label = %upgrade_effect
@onready var upgrade_cost_label:Label = %upgrade_cost
@onready var upgrade_cost_image:TextureRect = %upgrade_cost_image
@onready var card_background:NinePatchRect = %CardBackground
@onready var upgrade_type_image:TextureRect = %upgrade_type_image
@onready var loja = $"../../../.."
@export var modulate_time:float = 1.0
@export_category("Upgrades")
@export var possibilities_target :Dictionary[int,String]
@export var target_possibilities: Dictionary[String,Array]
var card_background_path:String
var upgrade_name:String
var upgrade_image_path:String
var upgrade_effect:String
var upgrade_cost:int
var basic_cost:int
var card_is_choosen:String
var buff:int
var sub_prop:int
var upgrade_cost_image_path:String
var upgrade_type_image_path:String
var error:bool = false
var vazio = null

const background_comum = "res://UI/loja da morte/Upgrade_custo_comum.png"
const background_incomum = "res://UI/loja da morte/Upgrade_custo_medio.png"
const background_rara = "res://UI/loja da morte/Upgrade_custo_raro.png"
const background_unico = "res://UI/loja da morte/Upgrade_unico.png"
const alma_comum = "res://UI/UI_images/Alma_Comum_UI.png"
const alma_incomum = "res://UI/UI_images/Alma_Zumbi_incomum.png"
const alma_rara = "res://UI/UI_images/Alma_zumbi_raro.png"
const vida_max = "res://UI/loja da morte/icones/Vida_max.png"
const stam_reg = "res://UI/loja da morte/icones/Stamina1.png"
const stam_max = "res://UI/loja da morte/icones/Stamina2.png"
const sword_damage = "res://UI/loja da morte/icones/Dano_arma_branca.png"
const less_spread = "res://UI/loja da morte/icones/Menor_espalhamento.png"
const more_speed = "res://UI/loja da morte/icones/Mais_velocidade_da_bala.png"
const more_pierce = "res://UI/loja da morte/icones/Mais_perfuracao.png"
const more_ammo = "res://UI/loja da morte/icones/Mais_municao.png"
const more_frags = "res://UI/loja da morte/icones/Mais_estilhacos.png"
const more_damage = "res://UI/loja da morte/icones/Mais_dano_na_bala.png"


func _ready() -> void:
	if error: start_card()
	error = false
	set_card()
	modulate.a = 0
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,modulate_time)
	
#Essa função inicializa o card, sorteando o tipo de carta que será.
func start_card() -> void:
	for i in range(1):
		var target = randi_range(0,possibilities_target.size()-1)
		var target_choosen = possibilities_target[target] 
		var card_affect = target_possibilities[target_choosen]
		card_is_choosen = card_affect[randi_range(0,card_affect.size()-1)]
		
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
				set_card_aumenta_magnum(GameManager.upgrade_magnum)
			"Bazuca":
				set_card_aumenta_bazuca(GameManager.upgrade_bazuca)
			"Estilhaco":
				set_card_aumenta_estilhaco(GameManager.upgrade_estilhaco)
			"Slow":
				set_card_aumenta_slow(GameManager.upgrade_slow)
			"Duas fases":
				set_card_aumenta_duas_fases(GameManager.upgrade_duas_fases)
			"Besta":
				set_card_aumenta_besta(GameManager.upgrade_besta)
			_:
				print_debug("Aumentou alguma outra coisa, talvez a ",card_is_choosen)

#Essa função adiciona os valores criados no objeto carta
func set_card():
	upgrade_name_label.text = upgrade_name
	upgrade_image.texture = load(upgrade_image_path)
	upgrade_effect_label.text = upgrade_effect
	upgrade_cost_label.text = "Custo: "+ str(upgrade_cost)
	upgrade_cost_image.texture = load(upgrade_cost_image_path)
	card_background.texture = load(card_background_path)
	if upgrade_type_image_path:
		upgrade_type_image.texture = load(upgrade_type_image_path)
####---------------------vvvvvv--------------------------####
#region determinar o tipo de texto e buff
#Essas funções servem para determinar o texto e o buff de cada carta.
func set_card_aumenta_algo(algo_up):
	upgrade_name = "Aumenta alguma coisa na " + card_is_choosen
	buff = 0
	upgrade_effect = "Isso vai fazer algo para a "+card_is_choosen+" só não sabemos o que ainda"
	basic_cost = randi_range(0,300000)
	calcula_custo_almas(basic_cost)
	
###-----Player-----###	
func set_card_aumenta_vida_max(vida_max_up):
	upgrade_image_path = vida_max
	upgrade_name = "Aumento de vida máxima"
	buff = randi_range(5,10)
	upgrade_effect = "Aumenta a vida máxima do jogador em "+ str(buff)
	basic_cost = (2*vida_max_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_stamina_max(stamina_max_up):
	upgrade_image_path = stam_max
	upgrade_name = "Aumento de Stamina Max"
	buff = randi_range(10,20)
	upgrade_effect = "Aumenta a Stamina máxima do jogador em "+ str(buff)
	basic_cost = (2*stamina_max_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_stamina_regen(stamina_rege_up):
	upgrade_image_path = stam_reg
	upgrade_name = "Aumento de Regeneração de stamina"
	buff = randi_range(1,5)
	upgrade_effect = "Aumenta a  regeneração de stamina do jogador em "+ str(buff)
	basic_cost = (2*stamina_rege_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
func set_card_aumenta_sword_damage(sword_damage_up):
	upgrade_image_path = sword_damage
	upgrade_name = "Aumento de dano da espada do jogador"
	buff = randi_range(1,5)
	upgrade_effect = "Aumenta o dano de ataque com espada do jogador em "+ str(buff)
	basic_cost = (2*sword_damage_up+buff)*(buff+1)/2
	calcula_custo_almas(basic_cost)
	
###-----Revolver-----###	
func set_card_aumenta_revolver(upgrade_revolver):
	upgrade_image_path = "res://weapons/revolver/revolver_icon_2.png"
	sub_prop = randi_range(0,3)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição do revólver"
		buff = randi_range(1,3)
		upgrade_effect = "Aumenta a munição máxima do revólver em " + str(buff)
		basic_cost = (2*upgrade_revolver[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano do revólver"
		buff = randi_range(2,10)
		upgrade_effect  = "Aumenta o dano do revólver em " + str(buff)
		basic_cost  = (2*upgrade_revolver[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 2:
		upgrade_type_image_path = more_pierce
		upgrade_name = "Aumento de perfuração"
		buff = randi_range(1,3)
		upgrade_effect = "Permite que a bala do revólver atravesse " + str(buff) + " zumbis a mais"
		basic_cost = (2*upgrade_revolver[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 3:
		if GameManager.upgrade_revolver[3] == 1:
			print_debug("Tentou")
			error = true
		upgrade_name = "Balas gemeas curvas"
		buff = 1
		upgrade_effect = "Transforma as balas do revólver em duas balas gêmeas que atiram juntas, orbitando uma a outra. \n Perfuração base 3 e dano base 30"
		basic_cost = 30000
		calcula_custo_almas(basic_cost)
		card_background_path = background_unico

###-----Metralhadora-----###
func set_card_aumenta_metralhadora(upgrade_metralhadora):
	upgrade_image_path = "res://weapons/machinegun/machinegun.png"
	sub_prop = randi_range(0,4)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição da metralhadora"
		buff = randi_range(10,30)
		upgrade_effect = "Aumenta a munição máxima da metralhadora em " + str(buff)
		basic_cost = (2*upgrade_metralhadora[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da metralhadora"
		buff = randi_range(1,3)
		upgrade_effect  = "Aumenta o dano da metralhadora em " + str(buff)
		basic_cost  = (2*upgrade_metralhadora[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 2:
		if GameManager.upgrade_metralhadora[2] <= 0:
			print_debug("Tentou")
			error = true
		upgrade_type_image_path = less_spread
		upgrade_name = "Mira melhor"
		buff = randi_range(min(10,GameManager.upgrade_metralhadora[2]),min(50,GameManager.upgrade_metralhadora[2]))
		upgrade_effect = "Reduz o espalhamento das balas em " +str(buff)+"%"
		basic_cost = snapped(10/((upgrade_metralhadora[sub_prop]-(buff))*0.01+0.01),1) #func set_card_aumenta_algo(algo_up):
		buff = -buff
		calcula_custo_almas(basic_cost)
	if sub_prop == 3:
		upgrade_type_image_path = more_speed
		upgrade_name = "Mais velocidade de tiro"
		buff = randi_range(20,60)
		upgrade_effect = "Aumenta a velocidade de tiro em " +str(buff)+"%"
		basic_cost = buff*GameManager.upgrade_metralhadora[sub_prop]/10
		calcula_custo_almas(basic_cost)
	if sub_prop == 4:
		if GameManager.upgrade_metralhadora[4] == 1:
			print_debug("Tentou")
			error = true
		upgrade_name = "Balas que seguem"
		buff = 1
		upgrade_effect = "Faz as balas da metralhadora seguirem o alvo mais próximo"
		basic_cost = 7000000
		calcula_custo_almas(basic_cost)
		card_background_path = background_unico
###-----Shotgun-----###		
func set_card_aumenta_shotgun(upgrade_shotgun):
	upgrade_image_path = "res://weapons/shotgun/shotgun_icon.png"
	sub_prop = randi_range(0,5)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição da shotgun"
		buff = randi_range(1,4)
		upgrade_effect = "Aumenta a munição máxima da shotgun em " + str(buff)
		basic_cost = (2*upgrade_shotgun[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da shotgun"
		buff = randi_range(5,10)
		upgrade_effect  = "Aumenta o dano da shotgun em " + str(buff)
		basic_cost  = (2*upgrade_shotgun[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 2:
		if GameManager.upgrade_shotgun[2] <= 0:
			print_debug("Tentou")
			error = true
		upgrade_type_image_path = less_spread
		upgrade_name = "Mira melhor"
		buff = randi_range(min(10,GameManager.upgrade_shotgun[2]),min(50,GameManager.upgrade_shotgun[2]))
		upgrade_effect = "Reduz o espalhamento das balas em " +str(buff)+"%"
		basic_cost = snapped(10/((upgrade_shotgun[sub_prop]-(buff))*0.01+0.01),1) #func set_card_aumenta_algo(algo_up):
		#print_debug("Denominador: "+ str(((upgrade_shotgun[sub_prop]-(buff))*0.01+0.01)))
		buff = -buff
		calcula_custo_almas(basic_cost)
	if sub_prop == 3:
		upgrade_name = "Alcance Maior"
		buff = randi_range(10,30)
		upgrade_effect = "Aumenta o alcance das balas em " +str(buff)+"%"
		basic_cost = buff*GameManager.upgrade_shotgun[sub_prop]/10
		calcula_custo_almas(basic_cost)
	if sub_prop == 4:
		upgrade_type_image_path = more_frags
		upgrade_name = "Mais estilhaços!"
		buff = randi_range(1,3)
		upgrade_effect = "Aumenta a quantidade de estilhaços em " + str(buff)
		basic_cost = (2*upgrade_shotgun[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 5:
		if GameManager.upgrade_shotgun[5] == 1:
			print_debug("Tentou")
			error = true
		upgrade_name = "Shotgun Boomerangue"
		buff = 1
		upgrade_effect = "Transforma as balas da shotgun em pequenos bumerangues, dando perfuração e fazendo elas retornarem ao atingirem a distância máxima.\n A shotgun perde a capacidade de empurrar os inimigos."
		basic_cost = 5000000
		calcula_custo_almas(basic_cost)
		card_background_path = background_unico
###-----Magnum-----###		
func set_card_aumenta_magnum(upgrade_magnum):
	upgrade_image_path = "res://weapons/magnum/magnum_icon.png"
	sub_prop = randi_range(0,1)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição da Magnum"
		buff = randi_range(1,4)
		upgrade_effect = "Aumenta a munição máxima da Magnum em " + str(buff)
		basic_cost = (2*upgrade_magnum[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da Magnum"
		buff = randi_range(5,10)
		upgrade_effect  = "Aumenta o dano da Magnum em " + str(buff)
		basic_cost  = (2*upgrade_magnum[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)

###-----Bazuca-----###		
func set_card_aumenta_bazuca(upgrade_bazuca):
	upgrade_image_path = "res://weapons/bazuca/bazuca.png"
	sub_prop = randi_range(0,2)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição da Bazuca"
		buff = randi_range(1,2)
		upgrade_effect = "Aumenta a munição máxima da Bazuca em " + str(buff)
		basic_cost = (2*upgrade_bazuca[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da Bazuca"
		buff = randi_range(10,20)
		upgrade_effect  = "Aumenta o dano da Bazuca em " + str(buff)
		basic_cost  = (2*upgrade_bazuca[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 2:
		if GameManager.upgrade_bazuca[2] == 1:
			print_debug("Tentou")
			error = true
		upgrade_name = "Tiro que divide"
		buff = 1
		upgrade_effect = "Após viajar por um tempo a bala se divide em duas, cada uma com uma explosão com 70% do tamanho e do dano da explosão original"
		basic_cost = 20000
		calcula_custo_almas(basic_cost)
		card_background_path = background_unico
###-----estilhaço-----###		
func set_card_aumenta_estilhaco(upgrade_estilhaco):
	upgrade_image_path = "res://weapons/arma_estilhaco/Arma_de_estilhaco.png"
	sub_prop = randi_range(0,2)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição da arma de estilhaços"
		buff = randi_range(1,4)
		upgrade_effect = "Aumenta a munição máxima da arma de estilhaços em " + str(buff)
		basic_cost = (2*upgrade_estilhaco[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da arma de estilhaços"
		buff = randi_range(5,10)
		upgrade_effect  = "Aumenta o dano da arma de estilhaços em " + str(buff)
		basic_cost  = (2*upgrade_estilhaco[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 2:
		upgrade_type_image_path = more_frags
		upgrade_name = "Mais estilhaços!"
		buff = randi_range(1,3)
		upgrade_effect = "Aumenta a quantidade de estilhaços em " + str(buff)
		basic_cost = (2*upgrade_estilhaco[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
###-----slow-----###		
func set_card_aumenta_slow(upgrade_slow):
	upgrade_image_path = "res://weapons/arma_slow/Arma_slow.png"
	sub_prop = randi_range(0,1)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição da arma de slow"
		buff = randi_range(1,4)
		upgrade_effect = "Aumenta a munição máxima da arma de slow em " + str(buff)
		basic_cost = (2*upgrade_slow[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da arma de slow"
		buff = randi_range(5,10)
		upgrade_effect  = "Aumenta o dano da arma de slow em " + str(buff)
		basic_cost  = (2*upgrade_slow[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
###-----duas fases-----###		
func set_card_aumenta_duas_fases(upgrade_duas_fases):
	upgrade_image_path = "res://weapons/duas_fases/Arma_fase_1.png"
	sub_prop = randi_range(0,1)
	if sub_prop == 0:
		upgrade_type_image_path = more_ammo
		upgrade_name = "Aumento de munição da arma de duas fases"
		buff = randi_range(1,4)
		upgrade_effect = "Aumenta a munição máxima da arma de duas fases em " + str(buff)
		basic_cost = (2*upgrade_duas_fases[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da arma de duas fases"
		buff = randi_range(5,10)
		upgrade_effect  = "Aumenta o dano da arma de duas fases em " + str(buff)
		basic_cost  = (2*upgrade_duas_fases[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
###-----besta-----###
func set_card_aumenta_besta(upgrade_besta):
	upgrade_image_path = "res://weapons/besta/Crossbow.png"
	sub_prop = randi_range(0,1)
	if sub_prop == 0:
		upgrade_type_image_path = more_pierce
		upgrade_name = "Aumento de perfuração da flecha da besta"
		buff = randi_range(1,4)
		upgrade_effect = "Aumenta a perfuração da flecha da besta em " + str(buff)
		basic_cost = (2*upgrade_besta[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
	if sub_prop == 1:
		upgrade_type_image_path = more_damage
		upgrade_name = "Aumento de dano da arma besta"
		buff = randi_range(5,10)
		upgrade_effect  = "Aumenta o dano da besta em " + str(buff)
		basic_cost  = (2*upgrade_besta[sub_prop]+buff)*(buff+1)/2
		calcula_custo_almas(basic_cost)
#func set_card_aumenta_algo(algo_up):
	#TODO

#endregion

#Essa função serve para aplicar o efeito quando o botão for apertado.
func _on_button_pressed() -> void:
	if not have_souls(upgrade_cost_image_path): return
	match card_is_choosen:
			"Vida_max":
				GameManager.vida_max_up += buff
				print_debug("Sua vida máxima agora é ",40+GameManager.vida_max_up)
			"Stamina_max":
				GameManager.stamina_max_up+=buff
				print_debug("Sua Stamina máxima agora é ",100+GameManager.stamina_max_up)
			"Stamina_rege":
				GameManager.stamina_rege_up+=buff
				print_debug("Stamina rege +")
			"sword_damage":
				GameManager.sword_damage_up+=buff
				print_debug("Sword +")
			"Revolver":
				GameManager.upgrade_revolver[sub_prop]+=buff
				print_debug("REVOLVER", GameManager.upgrade_revolver[sub_prop],sub_prop)
			"Metralhadora":
				GameManager.upgrade_metralhadora[sub_prop]+=buff
				print_debug(GameManager.upgrade_metralhadora[sub_prop])
			"Shotgun":
				GameManager.upgrade_shotgun[sub_prop]+=buff
				print_debug("SHOTGUN")
			"Magnum":
				GameManager.upgrade_magnum[sub_prop]+=buff
				print_debug("MAGNUM")
			"Bazuca":
				GameManager.upgrade_bazuca[sub_prop]+=buff
				print_debug("BAZUCA")
			"Estilhaco":
				GameManager.upgrade_estilhaco[sub_prop]+=buff
				print_debug("Estilhaco")
			"Slow":
				GameManager.upgrade_slow[sub_prop]+=buff
				print_debug("Slow")
			"Duas fases":
				GameManager.upgrade_duas_fases[sub_prop]+=buff
				print_debug("Duas fases")
			"Besta":
				GameManager.upgrade_besta[sub_prop]+=buff
				print_debug("Besta")
			_:
				print_debug("Aumentou alguma outra coisa, talvez a ",card_is_choosen)
	loja.reset_cards()
	loja.atualiza_almas()

#Essa função calcula os preços e adapta eles para a alma correspondente:
func calcula_custo_almas(custo_alma):
	if custo_alma < 999:
		upgrade_cost = custo_alma
		upgrade_cost_image_path = alma_comum
		card_background_path = background_comum
	elif custo_alma <999999:
		upgrade_cost = snapped(custo_alma/1000,1)
		upgrade_cost_image_path = alma_incomum
		card_background_path = background_incomum
	else:
		upgrade_cost = snapped(custo_alma/1000000,1)
		upgrade_cost_image_path = alma_rara
		card_background_path = background_rara

#Essa função checa se o jogador tem a quantidade de almas suficientes.
func have_souls(soul_type):
	if soul_type == alma_comum:
		if GameManager.alma_comum >= upgrade_cost:
			GameManager.alma_comum -= upgrade_cost
			print_debug("Você agora tem ",GameManager.alma_comum," almas")
			return true
		else:
			print_debug("VOCÊ NÃO TEM ALMA SUFICIENTE")
			loja.aviso_almas()
			return false
	elif soul_type == alma_incomum:
		if GameManager.alma_incomum >= upgrade_cost:
			GameManager.alma_incomum -= upgrade_cost
			print_debug("Você agora tem ",GameManager.alma_incomum," almas")
			return true
		else:
			print_debug("VOCÊ NÃO TEM ALMA SUFICIENTE")
			loja.aviso_almas()
			return false
	elif soul_type == alma_rara:
		if GameManager.alma_rara >= upgrade_cost:
			GameManager.alma_rara -= upgrade_cost
			print_debug("Você agora tem ",GameManager.alma_rara," almas")
			return true
		else:
			print_debug("VOCÊ NÃO TEM ALMA SUFICIENTE")
			loja.aviso_almas()
			return false
