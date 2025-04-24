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
		player.bullet_path = preload("res://Player/bullet.tscn")
		player.ammo = 6
		queue_free()
