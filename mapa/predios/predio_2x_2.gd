extends Node2D
@onready var predio_sprite:Sprite2D = $predio_sprite
@onready var predio_shape_collision: CollisionShape2D = $Area2D/CollisionShape2D
@export var sprites_alturas:Array[Texture2D]

func _ready() -> void:
	if randi_range(0,1) == 0:
		predio_sprite.texture = sprites_alturas[0]
		predio_shape_collision.shape.set_size(Vector2(301, 394.0))
		predio_shape_collision.position.y = -290.0
	else:
		predio_sprite.texture = sprites_alturas[1]
		predio_shape_collision.shape.set_size(Vector2(301, 275.0))
		predio_shape_collision.position.y = -230.5
		
	predio_sprite.frame = randi_range(0,3)
	if randi_range(0,1) == 0:
		predio_sprite.flip_h = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		modulate.a = 0.2
		#print(position.y, body.position.y)
		
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Jogador"):
		#var tween = create_tween()
		#tween.set_ease(Tween.EASE_IN)
		#tween.set_trans(Tween.TRANS_QUINT)
		#tween.tween_property(self,"modulate",Color.WHITE,2.0)
		##modulate.a = 1.0


func _on_area_2d_area_entered(area: Area2D) -> void:
	#print("Area entrou")
	if area.is_in_group("JogadorVisao"):
		modulate.a = 0.6


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("JogadorVisao"):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_QUINT)
		tween.tween_property(self,"modulate",Color.WHITE,0.0)
