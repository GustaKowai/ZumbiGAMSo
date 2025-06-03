extends Node2D

@onready var area_cola:Area2D = $AreaCola
@export var duration:float = 15.0
@export var glue_power:float = 5

func _ready() -> void:
	var bodys:Array[Node2D] = area_cola.get_overlapping_bodies() #Detecta todas as áreas que estão dentro da área de dano do inimigo
	for body in bodys:
		if body.is_in_group("enemies"): #Detecta se alguma área detectada é um inimigo
			body.modulate = Color.LIGHT_GOLDENROD
			var zombie_movement = body.get_node("FollowPlayer")
			zombie_movement.speed *= 1.0/glue_power

func _process(delta: float) -> void:
	duration -= delta
	if duration <= 0:
		despawn()
		
func despawn():
	queue_free()

func _on_area_cola_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.modulate = Color.LIGHT_GOLDENROD
		var zombie_movement = body.get_node("FollowPlayer")
		zombie_movement.speed *= 1.0/glue_power

func _on_area_cola_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.modulate = Color.WHITE
		var zombie_movement = body.get_node("FollowPlayer")
		zombie_movement.speed *= glue_power
