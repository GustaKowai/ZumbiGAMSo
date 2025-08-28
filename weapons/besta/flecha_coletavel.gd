extends Arma_Coletavel

func _ready() -> void:
	print("dropei uma flecha no chao",global_position,position)

func _on_area_2d_body_entered(body):
	coleta_arma(body)

func _on_timer_timeout() -> void:
	queue_free()
