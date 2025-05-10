extends Sprite2D


func _on_area_2d_body_entered(body):
	print("pegou")
	if body.is_in_group("Jogador"):
		var player = body
		#Se o jogador pegar, define como a arma carregada e define a munição:
		player.bullet_path = preload("res://weapons/bullet_magnum.tscn")
		player.weapon_path = preload("res://weapons/revolver_sprite.png")
		player.equiped_weapon.texture = player.weapon_path
		player.weapon_cooldown = 0.4
		player.ammo = 6
		queue_free()
