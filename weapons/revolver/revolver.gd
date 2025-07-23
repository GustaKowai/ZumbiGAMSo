#Esse aqui é o ITEM revólver, que é DROPADO pelos monstros. Ele instancia um revólver no player quando coletado
extends Arma_Coletavel

func _on_area_2d_body_entered(body):
	coleta_arma(body)
