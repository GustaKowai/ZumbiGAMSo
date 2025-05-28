extends Control
@onready var card_container = $VBoxContainer/CardContainer

@export var cartas:PackedScene

func _ready() -> void:
	for i in range(4):
		var card = cartas.instantiate()
		card.start_card()
		card_container.add_child(card)
