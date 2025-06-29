class_name MobSpawner
extends Node2D

@export var enemies:Array[PackedScene] #Array de criaturas possíveis de serem invocadas
@export var mobs_per_minute = 30.0
@export var spawn_chances: Array[float]
@onready var animation_player = $AnimationPlayer

#Iniciar o cooldown
var cooldown:float = 0
var buff_de_vida:float = 0

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
	cooldown = randf_range(interval/2,3*interval/2)
	
func spawn_zombie():#Essa é a função que invoca o zumbi.
	var enemy_index = randi_range(0,enemies.size()-1)
	var enemy_scene = enemies[enemy_index]
	var enemy:Enemy = get_random_enemy().instantiate()
	enemy.position = position
	enemy.enemy_health += snappedi((enemy.enemy_health*1.0/20.0)*buff_de_vida,1)
	get_parent().get_parent().add_child(enemy)
	GameManager.infection_level += GameManager.infection_power
	#print(GameManager.infection_level)

func get_random_enemy():
	var max_chance = 0.0
	for spawn_chance in spawn_chances:
		max_chance += spawn_chance
		
	var random_value = randf()*max_chance
	
	var enemy_chooser = 0.0
	for i in enemies.size():
		var choosed_enemy = enemies[i]
		var spawn_chance = spawn_chances[i] if i <spawn_chances.size() else 1.0
		if random_value <=spawn_chance + enemy_chooser:
			return choosed_enemy
		enemy_chooser += spawn_chance
	return enemies[0] 
