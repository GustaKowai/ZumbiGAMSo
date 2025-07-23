#Este é o item arma de estilhaco, dropado pelos zumbis. Ele instancia a arma de estilhaco no player quando coletado 

extends Arma_Coletavel

func _on_area_2d_body_entered(body):
	coleta_arma(body)
