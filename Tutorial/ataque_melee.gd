extends CanvasLayer

#Desabilitar a visao no inicio
func _ready() -> void:
	hide()

#Depois do sinal "dummy" recebido recebido habilitar a visao da cena
func chamou_melle():
	visible = true

#Recebe o sinal "morreu" para indicar q o jogador matou e dummy e essa cena deve sumir
func _on_dummy_morreu() -> void:
	queue_free()
