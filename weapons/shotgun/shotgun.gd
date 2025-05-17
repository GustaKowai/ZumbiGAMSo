#Esse aqui é o ITEM shotgun, que é DROPADO pelos monstros. Ele instancia uma shotgun no player quando coletado

extends Sprite2D
@export var weapon:PackedScene

func _on_area_2d_body_entered(body):
	print("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.weapon_collected.emit("res://weapons/shotgun/shotgun_icon.png") #Emite um sinal avisando que uma arma foi coletada
		var player = body
		var weapon_instance = weapon.instantiate()
		player.add_child(weapon_instance)
		queue_free()
