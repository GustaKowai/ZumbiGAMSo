extends StaticBody2D

@export var taunt_duration:float

func _ready() -> void:
	GameManager.is_taunting = true
	GameManager.taunt_position = position

func _process(delta: float) -> void:
	taunt_duration -=delta
	if taunt_duration <=0:
		despawn()
			
func despawn():
	GameManager.is_taunting = false
	queue_free()
