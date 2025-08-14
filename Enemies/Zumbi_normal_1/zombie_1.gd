class_name Enemy
extends CharacterBody2D

@onready var sprite_movimento:Sprite2D = $Movimento
@onready var sprite_ataque:Sprite2D = $Ataque
@onready var animation_player:AnimationPlayer = $AnimationPlayer

@export_category("Movimento")
@export var follow:Node2D

@export_category("Fight")
@export var enemy_health:int = 40
@export var health_for_buff:float = 1
@export var death_prefab:PackedScene
var player: Node2D

@export_category("Drops")
@export var items:Array[PackedScene]
@export_range(0,1) var drop_rate:float = 0.5
@export var drop_chances: Array[float]
@export_category("coins")
@export var coin:PackedScene
@export_range(0,1) var coins_rate:float = 0.5
@export var number_coins_max:int = 1
@export var number_coins_min:int = 1
@export var spread_area_radius:float = 10.0
@export_enum("Comum", "Incomum", "Rara") var alma_dropada: int

@onready var damage_digit_marker:Marker2D = $damage_digit_marker
@onready var damage_digit_prefab:PackedScene = preload("res://Misc/damage_digit.tscn")

var is_attacking:bool = false
var died:bool = false
var facing_position:String
var knockback:bool = false
var buff:float = 0

func _ready() -> void:
	enemy_health += snappedi(health_for_buff*buff,1) 
	#print_debug("Vida desse zumbi = ",enemy_health)

func damage(amount: int):
	enemy_health -=amount
	#piscar o inimigo:
	modulate = Color.ORANGE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
	#Mostrar o dano:
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = position
	
	get_parent().add_child(damage_digit)
	
	if enemy_health <=0 and not died: #IMPORTANTE para o inimigo morrer uma vez só (Sério, isso é relevante.)
		died = true
		die()

func die():
	#Animação de morte, se tiver:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	await drop_item()
	await drop_coins()
	GameManager.kills_count += 1
	if alma_dropada == 0:
		GameManager.alma_comum += 1
	if alma_dropada == 1:
		GameManager.alma_incomum += 1
	if alma_dropada == 2:
		GameManager.alma_rara += 1
	#print_debug(alma_dropada)
	GameManager.zombie_died.emit()
	GameManager.infection_level -= GameManager.infection_power
	queue_free()
	
func drop_item():
	if not items:
		#print ("Não tenho drop")
		return
	if randf() > drop_rate: return #Checa se ele dropará um item baseado na taxa de drop do monstro
	var item = get_random_drop_item().instantiate()
	item.position = position
	get_parent().add_child(item)
	
func get_random_drop_item():
	#Isso aqui é complicado mas funciona, confia.
	var max_chance = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
		
	var random_value = randf()*max_chance
	
	var item_chooser = 0.0
	for i in items.size():
		var droped_item = items[i]
		var drop_chance = drop_chances[i] if i <drop_chances.size() else 1.0
		if random_value <=drop_chance + item_chooser:
			return droped_item
		item_chooser += drop_chance
	return items[0] 
	
func drop_coins():
	if not coin:
		#print ("Não dropo dinheiro")
		return
	if randf() > coins_rate: return #Checa se ele dropará um item baseado na taxa de drop do monstro
	var number_coins = randi_range(number_coins_min,number_coins_max)
	for n in range(1,number_coins):
		var position_spread:Vector2 = Vector2(randf_range(-1,1),randf_range(-1,1))*spread_area_radius
		#print_debug(position_spread)
		var item = coin.instantiate()
		item.position = position+position_spread
		get_parent().add_child(item)
