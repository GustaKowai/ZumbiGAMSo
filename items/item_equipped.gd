extends Node2D


var item_loaded:PackedScene

func _ready() -> void:
	GameManager.item_collected.connect(on_item_collected)

func on_item_collected(string): #Essa função serve para largar a arma
	print("larguei item")
	queue_free()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("use_item"):
		var item = item_loaded.instantiate()
		item.position = get_parent().position
		get_parent().get_parent().add_child(item)
		GameManager.item_collected.emit(null)
		print("tentei usar o item")
		queue_free()
