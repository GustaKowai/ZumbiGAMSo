class_name arma_coletavel
extends Sprite2D

@export var weapon:PackedScene
@export var arma_string:String

func coleta_arma(body):
	#print_debug("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.weapon_collected.emit(arma_string) #Emite um sinal avisando que uma arma foi coletada
		var player = body
		var weapon_instance = weapon.instantiate()
		player.add_child(weapon_instance)
		queue_free()
