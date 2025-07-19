extends Node2D
@export var numero_de_lojas_abertas:int = 1

#@onready var polygon:Polygon2D = $Polygon2D
var filiais:Array
func _ready() -> void:
	filiais = self.find_children("*","Loja")
	GameManager.loja_fechada.connect(abre_loja)
	for i in range(0,numero_de_lojas_abertas-1):
		GameManager.loja_fechada.emit()
	#await get_tree().create_timer(2.0).timeout
	#GameManager.loja_fechada.emit()
	
func abre_loja():
	var loja:Loja = filiais[randi_range(0,filiais.size()-1)]
	if loja.esgotado:
		loja.open_shop()
		#print_debug("tentei abrir uma loja")
	else:
		abre_loja()
