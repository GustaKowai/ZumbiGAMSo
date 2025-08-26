extends CanvasLayer

signal fim

@export var item_scene:PackedScene
@export var fim_scene:PackedScene

var visivel = false

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	if GameManager.player.player_health == 40 and visivel :
		chamar_fim()

func chamou_item():
	visible = true
	var item = item_scene.instantiate()
	get_parent().add_child(item)
	item.global_position = Vector2(114,282)
	GameManager.player.player_shield = 0
	GameManager.player.player_health = 35
	visivel = true

func chamar_fim():
	queue_free()
	var fim = fim_scene.instantiate()
	get_parent().add_child(fim)
