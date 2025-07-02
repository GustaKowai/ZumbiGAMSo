class_name Cura_item
extends Sprite2D
@export var item:PackedScene
@export var item_string:String 
@export var image:String

func _on_area_2d_body_entered(body):
	#print_debug("pegou")
	if body.is_in_group("Jogador"): #Checa se o corpo que entrou no range é o player
		GameManager.item_collected.emit(image) #Emite um sinal avisando que uma arma foi coletada
		var player = body
		var item_instance = item.instantiate()
		item_instance.item_loaded = load(item_string)
		#print_debug(item_instance.item_loaded)
		player.add_child(item_instance)
		queue_free()
