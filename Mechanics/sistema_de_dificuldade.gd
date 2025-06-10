extends Node

@export var mob_spawner:MobSpawner
@export var initial_spawn_rate = 30.0
@export var mobs_increase_per_minute = 3.0
@export var wave_duration = 20.0
@export var break_intensity = 0.5
var time = 0.0
var time_for_nerf = 60
var number_of_nerfs:int = 1
var buff_de_vida:int = 0

func _process(delta):
	#Se der game over, parar
	if GameManager.is_game_over: return
	#Implementar temporizador
	time += delta
	var cos_wave = cos(time*TAU/wave_duration)
	var wave_factor = remap(cos_wave,-1,1,break_intensity,1)
	if (int(time)%time_for_nerf == 0):
		if int(time) >= time_for_nerf*number_of_nerfs:
			number_of_nerfs = number_of_nerfs + 1
			mobs_increase_per_minute *= 0.99
			buff_de_vida += 1
			#print("buffados e nerfados")
			#print(buff_de_vida)
			#print(mobs_increase_per_minute)
	var spawn_rate = initial_spawn_rate + mobs_increase_per_minute*(time/60.0)
	spawn_rate *=wave_factor
	
	mob_spawner.mobs_per_minute = spawn_rate
	mob_spawner.buff_de_vida = buff_de_vida
