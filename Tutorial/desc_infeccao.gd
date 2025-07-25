extends CanvasLayer

#Sinal para mandar o dummy e a cena de ataque melee aparecer
signal dummy

var quant_cliques = 0

#Desabilitar a visao no inicio
func _ready() -> void:
	hide()

#Depois do sinal recebido habilitar a visao da cena
func aparecer_infeccao():
	visible = true;

#Apos um clique com o botao esquerdo a cena some e emite o sinal "dummy"
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if quant_cliques == 4:
				dummy.emit()
				queue_free()
			else:
				quant_cliques += 1
