extends Control
@onready var card_container = $VBoxContainer/CardContainer

@export var cartas:PackedScene

func _ready() -> void:
	set_cards()
		
func set_cards():
	for i in range(4):
		var card = cartas.instantiate()
		card.start_card()
		card_container.add_child(card)

func reset_cards():
	for n in card_container.get_children():
		card_container.remove_child(n)
		n.queue_free()
	set_cards()


func _on_button_pressed() -> void:
	reset_cards()
