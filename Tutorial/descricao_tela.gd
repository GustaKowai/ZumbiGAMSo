extends CanvasLayer

var quant_cliques = 0

#Desabilitar a visao no inicio
func _ready() -> void:
	hide()

#Depois do sinal "moedas" recebido habilitar a visao da cena
func aparecer_desc_tela():
	visible = true;

#Apos 2 cliques(total de cenas que usam esse molde da morte) a cena some
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if quant_cliques == 4:
				queue_free()
			else:
				quant_cliques += 1
