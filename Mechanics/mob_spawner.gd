class_name MobSpawner
extends Node2D

#buffs dos zumbis
@export var num_ativacao_buff:int = 3
#Dados dos zumbis
@export var mobs_per_minute = 30.0
@export var enemies:Array[PackedScene] #Array de criaturas possíveis de serem invocadas
@export var spawn_chances: Array[float]
@onready var animation_player = $AnimationPlayer
@export_category("Buffs de spawn")
@export var buff_spawn_policial:float
@export var tempo_buff_spawn_policial_seg:int
@export var buff_spawn_piao:float
@export var tempo_buff_spawn_piao_seg:int
@export var buff_spawn_tanque:float
@export var tempo_buff_spawn_tanque_seg:int

var controle_tempo:int = 0
#buff por spawn
var numero_de_ativacoes:int = 0

#Iniciar o cooldown
var cooldown:float = 0

func _ready():
	pass # Replace with function body.


func _process(delta):
	check_spawn_rates()
	
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
	numero_de_ativacoes += 1
	enemy.buff = snappedi(numero_de_ativacoes/num_ativacao_buff,1) 
	#print_debug("Numero de ativações e buffs: ",numero_de_ativacoes," ", enemy.buff)
	get_parent().get_parent().add_child(enemy)
	GameManager.infection_level += GameManager.infection_power
	#print_debug(GameManager.infection_level)

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

func check_spawn_rates():
	var current_time = snappedi(GameManager.time_elapsed,1)
	#print_debug(current_time)
	if current_time == controle_tempo: return
	controle_tempo = current_time
	if current_time%tempo_buff_spawn_policial_seg == 0:
		spawn_chances[1] += buff_spawn_policial
		if spawn_chances[1] > 1: spawn_chances[1] = 1
	if current_time%tempo_buff_spawn_piao_seg == 0:
		spawn_chances[2] += buff_spawn_piao
		if spawn_chances[2] > 1: spawn_chances[2] = 1
	if current_time%tempo_buff_spawn_tanque_seg == 0:
		spawn_chances[3] += buff_spawn_tanque
		if spawn_chances[3] > 0.5: spawn_chances[3] = 0.5
