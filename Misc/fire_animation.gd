extends AnimatedSprite2D

var pos:Vector2
var rota:float
var dir: float

func _ready() -> void:
	global_position = pos
	global_rotation = rota

func _on_animation_finished() -> void:
	queue_free()
