extends CanvasLayer

#Sinal para mandar a cena da descricao da vida e escudo aparecer
signal vida

var quant_cliques = 0

#Desabilitar a visao no inicio
func _ready() -> void:
	hide()

#Depois do sinal "moedas" recebido habilitar a visao da cena
func aparecer_moedas():
	visible = true;

#Apos um clique com o botao esquerdo a cena some e emite o sinal "vida"
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if quant_cliques == 1:
				vida.emit()
				queue_free()
			elif quant_cliques == 0:
				quant_cliques += 1
