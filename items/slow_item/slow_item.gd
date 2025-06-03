extends Node2D
@export var item:PackedScene

func _on_area_2d_body_entered(body):
	#print("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.item_collected.emit("res://items/slow_item/cola_item.png") #Emite um sinal avisando que uma arma foi coletada
		var player = body
		var item_instance = item.instantiate()
		item_instance.item_loaded = load("res://items/slow_item/slow_object.tscn")
		player.add_child(item_instance)
		queue_free()
