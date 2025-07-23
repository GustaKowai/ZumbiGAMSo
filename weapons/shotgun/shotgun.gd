#Esse aqui é o ITEM shotgun, que é DROPADO pelos monstros. Ele instancia uma shotgun no player quando coletado

extends Arma_Coletavel

func _on_area_2d_body_entered(body):
	coleta_arma(body)
