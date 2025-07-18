#Este é o item arma de estilhaco, dropado pelos zumbis. Ele instancia a arma de estilhaco no player quando coletado 

extends Sprite2D
@export var weapon:PackedScene

func _on_area_2d_body_entered(body):
	#print("pegou")
	if body.is_in_group("Jogador"):
		GameManager.weapon_collected.emit("res://weapons/arma_estilhaco/Arma_de_estilhaco.png") #Emite um sinal avisando que uma arma foi coletada
		var player = body
		var weapon_instance = weapon.instantiate()
		player.add_child(weapon_instance)
		queue_free()
		
