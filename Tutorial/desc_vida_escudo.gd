extends CanvasLayer

#Sinal para mandar a descricao dos itens e arams aparecerem
signal armas

var quant_cliques = 0

#Desabilitar a visao no inicio
func _ready() -> void:
	hide()

#Depois do sinal recebido habilitar a visao da cena
func aparecer_vida():
	visible = true;

#Apos um clique com o botao esquerdo a cena some e emite o sinal "armas"
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if quant_cliques == 2:
				armas.emit()
				queue_free()
			else:
				quant_cliques += 1
