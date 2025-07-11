extends Node2D

@export var speed = 0.5

var enemy: Enemy
var sprite:Sprite2D
var animation_player:AnimationPlayer
var var_diff:Vector2
var position_running = "side" 
var nav_agent:NavigationAgent2D
var knockback_direction:Vector2 = Vector2(0,0)

func _ready():
	enemy = get_parent()
	sprite =enemy.get_node("Movimento")
	animation_player = enemy.get_node("AnimationPlayer")
	nav_agent = get_node("NavigationAgent2D")
	#print_debug(nav_agent.path_desired_distance)

func _physics_process(_delta:float):
	if GameManager.is_game_over: return
	#print_debug(position.distance_squared_to(GameManager.player_position))
	if global_position.distance_squared_to(GameManager.player_position) > 400000:
		#print_debug("navegando",global_position.distance_squared_to(GameManager.player_position))
		var_diff = to_local(nav_agent.get_next_path_position()) #pega o próximo ponto do caminho calculado para o jogador
	else:
		var_diff = try_aim()
	if not enemy.is_attacking and not enemy.knockback:
		move()
	if enemy.knockback:
		move_back()
		
func move():
	var normalize_diffe = var_diff.normalized() #Transforma o vetor apontando para o próximo ponto em um versor
	var input_vector = normalize_diffe 
	enemy.velocity = input_vector * speed * 100.0
	#Determinar qual animação será usada:
	if abs(var_diff.x) >= abs(var_diff.y):
		position_running = "side"
		animation_player.play("Walk Side")
		#girar sprite:
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x <0:
			sprite.flip_h = true
	elif var_diff.y < 0:
		position_running = "up"
		animation_player.play("Walk Up")
	else:
		position_running = "down"
		animation_player.play("Walk Down")
		
	enemy.facing_position = position_running
	enemy.move_and_slide()
	
func make_path(): #Calcula e cria o melhor caminho até o jogador, desviando de obstáculos
	var player_position = GameManager.player_position
	if GameManager.is_taunting:
		player_position = GameManager.taunt_position
	nav_agent.target_position = player_position
		


func _on_timer_timeout():
	make_path()

func knockback(direcao:Vector2,duracao:float)->void:
	knockback_direction = direcao
	enemy.knockback = true
	#print_debug("Tomou knockback")
	await get_tree().create_timer(duracao).timeout
	enemy.knockback = false
	
func move_back():
	var normalize_diffe = knockback_direction.normalized() #Transforma o vetor apontando para o próximo ponto em um versor
	var input_vector = normalize_diffe 
	enemy.velocity = input_vector * 0.0
	#print_debug(enemy.velocity)
	enemy.move_and_slide()

func try_aim():
	var aim = GameManager.player_position-global_position
	if abs(aim.x) > abs(aim.y):
		if aim.y > 0:
			return Vector2.DOWN
		else:
			return Vector2.UP
	else:
		if aim.x > 0:
			return Vector2.RIGHT
		else:
			return Vector2.LEFT


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	pass # Replace with function body.
