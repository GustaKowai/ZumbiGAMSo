extends CanvasLayer

signal item

var dummies_mortos = 0

@export var weapon: PackedScene
@export var inimigo_scene:PackedScene

func _ready() -> void:
	hide()

func chamou_arma():
	visible = true
	var weapon_instance = weapon.instantiate()
	get_parent().add_child(weapon_instance)
	weapon_instance.global_position = Vector2(-105,130)
	
	var inimigo1 = inimigo_scene.instantiate()
	get_parent().add_child(inimigo1)  # adiciona na cena
	inimigo1.global_position = Vector2(-392, 130)
	inimigo1.morreu.connect(matou_dummies)
	
	var inimigo2 = inimigo_scene.instantiate()
	get_parent().add_child(inimigo2)  # adiciona na cena
	inimigo2.global_position = Vector2(182, 130)
	inimigo2.scale.x = -1
	inimigo2.morreu.connect(matou_dummies)

func matou_dummies():
	dummies_mortos += 1
	if dummies_mortos == 2:
		queue_free()
		item.emit()
