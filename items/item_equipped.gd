extends Node2D

var object_path:String

func _ready() -> void:
	
	GameManager.item_collected.connect(on_item_collected)

func on_item_collected(string): #Essa função serve para largar a arma
	print("larguei item")
	queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_item"):
		var loaded_object = load(object_path)
		var object = loaded_object.instantiate()
		object.position = get_parent().position
		get_parent().get_parent().add_child(object)
		GameManager.item_collected.emit(null)
		print("tentei usar o item")
		queue_free()
