extends StaticBody2D

@export var tempo_para_explodir: float
@export var dano_inimigos: int
@export var dano_player: int
@onready var area_da_explosao = $area_de_dano

func _process(delta: float) -> void:
	tempo_para_explodir -=delta
	if tempo_para_explodir <=0:
		explode()
		despawn()

func despawn():
	queue_free()

func explode():
	#Escrita de controle 
	print("EXPLODIUUU")
	#Array com todas as areas afetadas pela explosao
	var areas_afetadas:Array[Area2D] = area_da_explosao.get_overlapping_areas()
	#Verificacao das areas afetadas
	for areas in areas_afetadas:
		#Se a area for de inimigo, ele recebe o dano de inimigo
		if areas.is_in_group("EnemyHitBox"):
			var enemy:Enemy = areas.get_parent()
			enemy.damage(dano_inimigos)
		#Se a area for do Jogador, ele recebe o dano de player
		elif areas.is_in_group("JogadorHitBox"):
			var jogador:Jogador = areas.get_parent()
			jogador.damage(dano_player)
