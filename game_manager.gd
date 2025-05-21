extends Node

#Sinais
signal game_over
signal weapon_collected()
signal item_collected()
signal coin_collected()
signal player_damaged()
#Gerenciamento da run:
var player:Jogador
var player_position: Vector2
var ammo:int = 0
var infection_level:int = 0
var infection_power:int = 2
var weapon_cd:float
var texto_morte:String
var is_taunting:bool = false
var taunt_position:Vector2

#informações da run:
var time_elapsed:float = 0.0
var time_elapsed_string: String
var ammo_count:int = 0
var kills_count:int = 0
var is_game_over:bool = false
var coin_count = 0



#Finalização do jogo em caso de game over
func end_game():
	if is_game_over:return
	is_game_over = true
	game_over.emit()

#Reset do jogo:
func reset():
	player = null
	player_position = Vector2.ZERO
	is_game_over = false
	time_elapsed = 0.0
	time_elapsed_string = "00:00"
	ammo_count = 0
	kills_count = 0
	infection_level = 0
	coin_count = 0
	#Se não fizer isso ele mantém entre as runs;
	
	
func _process(delta):
	time_elapsed += delta
	var seconds_elapsed = floori(time_elapsed)
	var minutes = floori(seconds_elapsed/60.0)
	var seconds = seconds_elapsed % 60
	time_elapsed_string = "%02d:%02d" % [minutes,seconds]
	
