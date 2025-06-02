extends Node2D

@export var quantidade_cura: int

func _ready() -> void:
	#Chamada para a funcao que ira curar
	heal_player(quantidade_cura)
	
func heal_player(vida_curada: int) -> void:
	#variavael que armazena a quantidade de vida do player antes da cura
	var controle_de_vida = GameManager.player.player_health
	#Casos em que com a cura a vida do player passaria do limite
	#Ex: se o jogador tiver 37 de vida ao curar 5 de vida ele deve ir para 40(limte de vida) e nao 42
	if controle_de_vida > (GameManager.player.max_health - vida_curada) and controle_de_vida <= GameManager.player.max_health:
		GameManager.player.player_health = GameManager.player.max_health
		print("curou para vida maxima")
		GameManager.life_changed.emit()
	#Caso geral em que so adiciona a quantidade da pocao a vida do player
	else:
		GameManager.player.player_health += vida_curada
		print("curou 5")
		GameManager.life_changed.emit()
	queue_free()
