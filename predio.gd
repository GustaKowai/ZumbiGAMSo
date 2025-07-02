class_name Predio
extends Node2D
@onready var predio_sprite:Sprite2D = $predio_sprite
@onready var predio_shape_collision: CollisionShape2D = $Area2D/CollisionShape2D
@export var sprite:Texture2D
@export var sprites_3altura:Array[Texture2D]
@export var sprites_2altura:Array[Texture2D]
@export var sprites:Array[Texture2D]
func _ready() -> void:
	if randi_range(0,1) == 0:
		sprites = sprites_3altura
		predio_shape_collision.shape.set_size(Vector2(366, 344.0))
		predio_shape_collision.position.y = -50.0
	else:
		sprites = sprites_2altura
		predio_shape_collision.shape.set_size(Vector2(366, 217.0))
		predio_shape_collision.position.y = 11.5
	predio_sprite.texture = sprites[randi_range(0,sprites.size()-1)]
	if randi_range(0,1) == 0:
		predio_sprite.flip_h = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		modulate.a = 0.2
		#print_debug(position.y, body.position.y)
		
#func _on_area_2d_body_exited(body: Node2D) -> void:
	#if body.is_in_group("Jogador"):
		#var tween = create_tween()
		#tween.set_ease(Tween.EASE_IN)
		#tween.set_trans(Tween.TRANS_QUINT)
		#tween.tween_property(self,"modulate",Color.WHITE,2.0)
		##modulate.a = 1.0


func _on_area_2d_area_entered(area: Area2D) -> void:
	#print_debug("Area entrou")
	if area.is_in_group("JogadorVisao"):
		modulate.a = 0.6


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("JogadorVisao"):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.set_trans(Tween.TRANS_QUINT)
		tween.tween_property(self,"modulate",Color.WHITE,0.0)
