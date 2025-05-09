extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	print("pegou")
	if body.is_in_group("Jogador"):
		var player = body
		#Se o jogador pegar, define como a arma carregada e define a munição:
		player.bullet_path = preload("res://weapons/bullet.tscn")
		player.weapon_path = preload("res://weapons/revolver_sprite.png")
		player.equiped_weapon.texture = player.weapon_path
		player.weapon_cooldown = 0.2
		player.ammo = 6
		queue_free()
