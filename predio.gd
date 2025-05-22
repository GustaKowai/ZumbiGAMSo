extends Node2D
@onready var predio_sprite:Sprite2D = $predio_sprite
@export var sprite:Texture2D
func _ready() -> void:
	predio_sprite.texture = sprite


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		modulate.a = 0.2
		print(position.y, body.position.y)
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_QUINT)
		tween.tween_property(self,"modulate",Color.WHITE,2.0)
		#modulate.a = 1.0
