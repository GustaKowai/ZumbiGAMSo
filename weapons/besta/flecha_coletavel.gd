extends Arma_Coletavel

func _ready() -> void:
	#print_debug("dropei uma flecha no chao")
	pass
func _on_area_2d_body_entered(body):
	coleta_arma(body)

func _on_timer_timeout() -> void:
	queue_free()


func _on_tree_entered() -> void:
	#print_debug("entrei")
	pass
