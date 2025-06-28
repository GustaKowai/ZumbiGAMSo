class_name Cura_overheal
extends Node2D

@export var quantidade_cura: int
@export var cura_extra:bool

func _ready() -> void:
	#Chamada para a funcao que ira curar
	heal_player(quantidade_cura)
	
func heal_player(vida_curada: int) -> void:
	#variavael que armazena a quantidade de vida do player antes da cura
	var vida_atual = GameManager.player.player_health
	#Caso em que o jogador está com a vida máxima e só o escudo irá aumentar
	if vida_atual == GameManager.player.max_health:
		GameManager.player.player_shield += vida_curada
		print("Adicionou " + str(vida_curada) + " ao escudo")
	#Casos em que com a cura a vida do player e adiciona o restante ao escudo
	#Ex: se o jogador tiver 37 de vida ao curar 5 de vida ele deve ir para 40(limte de vida) e nao 42
	elif vida_atual > (GameManager.player.max_health - vida_curada) and vida_atual <= GameManager.player.max_health:
		var cura_usada_para_vida = GameManager.player.max_health - vida_atual
		var cura_usada_para_escudo = vida_curada - cura_usada_para_vida
		GameManager.player.player_health = GameManager.player.max_health
		GameManager.player.player_shield = cura_usada_para_escudo
		print("curou para vida maxima e adicionou " + str(cura_usada_para_escudo) + " de escudo")
	#Caso geral em que so adiciona somente a quantidade da pocao a vida do player
	else:
		GameManager.player.player_health += vida_curada
		print("curou " + str(quantidade_cura))
	queue_free()
