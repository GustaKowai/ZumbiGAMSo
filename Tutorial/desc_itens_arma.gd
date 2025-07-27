extends CanvasLayer

#Sinal para mandar a descricao da barra de infeccao aparecer
signal infeccao

var quant_cliques = 0

#Desabilitar a visao no inicio
func _ready() -> void:
	hide()

#Depois do sinal recebido "armas" habilitar a visao da cena
func aparecer_armas():
	visible = true;

#Apos um clique com o botao esquerdo a cena some e emite o sinal "infeccao"
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if quant_cliques == 3:
				infeccao.emit()
				queue_free()
			else:
				quant_cliques += 1
