class_name MobSpawner
extends Node2D

@export var creatures:Array[PackedScene] #Array de criaturas possíveis de serem invocadas
@export var mobs_per_minute = 30.0
@onready var animation_player = $AnimationPlayer

#Iniciar o cooldown
var cooldown = 0


func _ready():
	pass # Replace with function body.


func _process(delta):
	
	#Se quiser que apenas os spawners próximos ao player invoquem monstros:
	if position.distance_to(GameManager.player_position) > 1500:return
	#Cooldown entre invocação de monstros:
	cooldown -= delta
	if cooldown>0:return
	set_cooldown()
	animation_player.play("Surge")#Essa animação contém um spawn_zombie() dentro dela.
	
	
func set_cooldown(): #Essa função determina um cooldown aleatório ao redor do cooldown pre-definido
	var interval = 60.0/mobs_per_minute
	cooldown = randi_range(interval/2,3*interval/2)
	
func spawn_zombie():#Essa é a função que invoca o zumbi.
	var creature_index = randi_range(0,creatures.size()-1)
	var creature_scene = creatures[creature_index]
	var creature = creature_scene.instantiate()
	creature.position = position
	get_parent().add_child(creature)
	GameManager.infection_level += GameManager.infection_power
	#print(GameManager.infection_level)
