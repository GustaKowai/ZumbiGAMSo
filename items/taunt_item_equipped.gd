extends Node2D

@onready var item_path = preload("res://items/taunt_object.tscn")

func _ready() -> void:
	
	GameManager.item_collected.connect(on_item_collected)

func on_item_collected(string): #Essa função serve para largar a arma
	print("larguei item")
	queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use_item"):
		var item = item_path.instantiate()
		item.position = get_parent().position
		get_parent().get_parent().add_child(item)
		GameManager.item_collected.emit(null)
		print("tentei usar o item")
		queue_free()
