class_name Enemy
extends CharacterBody2D

@onready var sprite_movimento:Sprite2D = $Movimento
@onready var sprite_ataque:Sprite2D = $Ataque
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var follow:Node2D = $FollowPlayer

@export_category("Fight")
@export var enemy_health:int = 40
@export var death_prefab:PackedScene
@export var player: Node2D
@export_category("Drops")
@export var items:Array[PackedScene]
@export_range(0,1) var drop_rate:float = 0.5
@export var drop_chances: Array[float]

@onready var damage_digit_marker:Marker2D = $damage_digit_marker
@onready var damage_digit_prefab:PackedScene = preload("res://Misc/damage_digit.tscn")

var is_attacking:bool = false
var died:bool = false
var facing_position:String

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
	
	drop_item()
	GameManager.kills_count += 1
	GameManager.alma_comum += 1
	GameManager.zombie_died.emit()
	GameManager.infection_level -= GameManager.infection_power
	queue_free()
	
func drop_item():
	if not items:
		print ("Não tenho drop")
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
