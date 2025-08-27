extends CanvasLayer

signal arma

@export var inimigo_scene:PackedScene

#Desabilitar a visao no inicio
func _ready() -> void:
	hide()

#Depois do sinal "dummy" recebido recebido habilitar a visao da cena
func chamou_melle():
	visible = true
	var inimigo = inimigo_scene.instantiate()
	get_parent().add_child(inimigo)  # adiciona na cena
	inimigo.global_position = Vector2(-392, 68)
	inimigo.morreu.connect(_on_dummy_morreu)

#Recebe o sinal "morreu" para indicar q o jogador matou e dummy e essa cena deve sumir
func _on_dummy_morreu() -> void:
	arma.emit()
	queue_free()
