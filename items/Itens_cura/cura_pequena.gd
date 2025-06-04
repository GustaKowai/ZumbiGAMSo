extends Sprite2D
@export var item:PackedScene
var image:String = "res://items/Itens_cura/potion__pequeno_pokemon.png"
func _on_area_2d_body_entered(body):
	print("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.item_collected.emit(image) #Emite um sinal avisando que uma arma foi coletada
		var player = body
		var item_instance = item.instantiate()
		item_instance.item_loaded = load("res://items/Itens_cura/cura_pequena_objeto.tscn")
		player.add_child(item_instance)
		queue_free()
