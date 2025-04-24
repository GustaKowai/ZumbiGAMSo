extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	print("Pegou")
	if body.is_in_group("Jogador"):
		print("Pegou mesmo")
		var player = body
		player.bullet_path = preload("res://Player/bullet.tscn")
		player.ammo = 6
		queue_free()
