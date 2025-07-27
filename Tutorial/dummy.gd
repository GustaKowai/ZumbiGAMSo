extends Enemy

#Sinal para indicar que o dummy morreu
signal morreu

#Esconde o dummy em primeiro momento
func _ready() -> void:
	hide()

#Habilita a visao ao receber o sinal "dummy"
func chamou_dummy():
	visible = true

#Função de morrer que emite o sinal "morreu"
func die():
	#Animação de morte, se tiver:
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	await drop_item()
	await drop_coins()
	GameManager.kills_count += 1
	if alma_dropada == 0:
		GameManager.alma_comum += 1
	if alma_dropada == 1:
		GameManager.alma_incomum += 1
	if alma_dropada == 2:
		GameManager.alma_rara += 1
	#print_debug(alma_dropada)
	GameManager.zombie_died.emit()
	GameManager.infection_level -= GameManager.infection_power
	emit_signal("morreu")
	queue_free()
