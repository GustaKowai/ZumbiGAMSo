extends Arma_Coletavel

func _ready() -> void:
	weapon = preload("res://weapons/besta/besta_weapon.tscn")

func _on_area_2d_body_entered(body):
	coleta_arma(body)

func _on_timer_timeout() -> void:
	queue_free()
