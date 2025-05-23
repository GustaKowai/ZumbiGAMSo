extends TileMapLayer

@onready var obstacles:TileMapLayer = $"../Obstacles Collision"
@onready var timer:Timer = $Timer
func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	if coords in obstacles.get_used_cells_by_id(0):
		return true
	return false

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0,null)


#Função de teste, vai transformando a rua próxima do jogador em água. A ideia é usar isso para criar obstáculos para o jogador e evitar que ele fique muito tempo parado no mesmo lugar
#func _on_timer_timeout() -> void:
	#if GameManager.player.position:
		#var player_position = GameManager.player.position
		#var rand_vector = Vector2(randf_range(90,800),0)
		#rand_vector = rand_vector.rotated(randf_range(0,2*PI))
		#var position_choosen = player_position + rand_vector
		#print(player_position,position_choosen)
		#var tile_position = local_to_map(position_choosen)
		#print(tile_position)
		#var tile_data:TileData = get_cell_tile_data(tile_position)
		#print(tile_data)
		#if tile_data:
			#var e_rua = tile_data.get_custom_data("e_rua")
			#if e_rua:
				#set_cell(tile_position,0,Vector2i(2,5))
			#else:
				#print("não é rua")
		#timer.start()
