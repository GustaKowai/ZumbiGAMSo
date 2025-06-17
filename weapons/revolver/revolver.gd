#Esse aqui é o ITEM revólver, que é DROPADO pelos monstros. Ele instancia um revólver no player quando coletado

extends Sprite2D
@export var weapon:PackedScene

func _on_area_2d_body_entered(body):
	#print("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.weapon_collected.emit("res://weapons/revolver/revolver_icon_2.png") #Emite um sinal avisando que uma arma foi coletada
		var player = body
		#Se o jogador pegar, define como a arma carregada e define a munição:
		#player.bullet_path = preload("res://weapons/bullet.tscn")
		#player.weapon_path = preload("res://weapons/revolver_sprite.png")
		#player.equiped_weapon.texture = player.weapon_path
		#player.weapon_cooldown = 0.2
		#player.ammo = 6
		#Instancia a arma para o jogador poder usar ela.
		var weapon_instance = weapon.instantiate()
		player.add_child(weapon_instance)
		queue_free()
