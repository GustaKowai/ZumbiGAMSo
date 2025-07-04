extends Sprite2D

func _ready() -> void:
	ghosting()

func set_property(ghost_pos:Vector2,ghost_scale:Vector2,ghost_color:Color):
	position = ghost_pos
	scale = ghost_scale
	modulate = ghost_color

func ghosting():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"self_modulate",Color(1.0, 1.0, 1.0, 0),0.7)
	await tween.finished
	queue_free()
