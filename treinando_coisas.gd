extends Node2D

@onready var tilemap:TileMapLayer = $TileMapLayer
@onready var timer:Timer = $TileMapLayer/Timer
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		var local_position = tilemap.local_to_map(GameManager.player.position)
		var tile_data:TileData = tilemap.get_cell_tile_data(local_position)
		if tile_data:
			var is_green = tile_data.get_custom_data("green")
			if is_green:
				#tilemap.set_cell(local_position + Vector2i(1,0),0,Vector2i(0,3))
				#tilemap.set_cell(local_position + Vector2i(-1,0),0,Vector2i(0,3))
				#tilemap.set_cell(local_position + Vector2i(-1,-1),0,Vector2i(0,3))
				#tilemap.set_cell(local_position + Vector2i(-1,1),0,Vector2i(0,3))
				#tilemap.set_cell(local_position + Vector2i(1,1),0,Vector2i(0,3))
				#tilemap.set_cell(local_position + Vector2i(1,-1),0,Vector2i(0,3))
				#tilemap.set_cell(local_position + Vector2i(0,-1),0,Vector2i(0,3))
				#tilemap.set_cell(local_position + Vector2i(0,1),0,Vector2i(0,3))
				tilemap.set_cell(local_position,0,Vector2i(0,3))
				#TOMAR CUIDADO COM ISSO, PODE PRENDER O JOGADOR
func _on_timer_timeout() -> void:
	if GameManager.player.position:
		var player_position = GameManager.player.position
		var rand_vector = Vector2(randf_range(30,100),0)
		rand_vector = rand_vector.rotated(randf_range(0,2*PI))
		var position_choosen = player_position + rand_vector
		print(player_position,position_choosen)
		var tile_position = tilemap.local_to_map(position_choosen)
		print(tile_position)
		var tile_data:TileData = tilemap.get_cell_tile_data(tile_position)
		print(tile_data)
		if tile_data:
			var is_green = tile_data.get_custom_data("green")
			if is_green:
				tilemap.set_cell(tile_position,0,Vector2i(0,3))
			else:
				print("não é rua")
		timer.start()
