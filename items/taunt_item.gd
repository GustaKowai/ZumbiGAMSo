extends Sprite2D
@export var item:PackedScene

func _on_area_2d_body_entered(body):
	print("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.item_collected.emit("res://a-radio-tape-in-pixel-art-style-vector.jpg") #Emite um sinal avisando que uma arma foi coletada
		var player = body
		var item_instance = item.instantiate()
		player.add_child(item_instance)
		queue_free()
