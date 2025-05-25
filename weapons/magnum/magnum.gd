#item magnum dropado
extends Sprite2D
@export var weapon:PackedScene

func _on_area_2d_body_entered(body):
	print("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.weapon_collected.emit("res://weapons/magnum/magnum_icon.png") #Emite um sinal avisando que uma arma foi coletada
		var player = body
		
		#Instancia a arma para o jogador poder usar ela.
		var weapon_instance = weapon.instantiate()
		player.add_child(weapon_instance)
		queue_free()
