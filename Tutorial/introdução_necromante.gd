extends CanvasLayer

signal moedas

@export var desc_tela:PackedScene
@export var desc_tela_moedas:PackedScene

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			
			moedas.emit()

			queue_free()
