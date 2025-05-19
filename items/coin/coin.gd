extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.coin_count += 1
		queue_free()
