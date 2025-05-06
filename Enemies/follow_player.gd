extends Node2D

@export var speed = 0.5

var enemy: Enemy
var sprite:Sprite2D
var animation_player:AnimationPlayer
var var_diff:Vector2
var position_running = "side" 
var dmg_area:Area2D
var nav_agent:NavigationAgent2D

func _ready():
	enemy = get_parent()
	sprite =enemy.get_node("Sprite2D")
	dmg_area = enemy.get_node("DmgArea")
	animation_player = enemy.get_node("AnimationPlayer")
	nav_agent = get_node("NavigationAgent2D")
	

func _physics_process(_delta:float):
	if GameManager.is_game_over: return
	
	var_diff = to_local(nav_agent.get_next_path_position()) #pega o próximo ponto do caminho calculado para o jogador
	if not enemy.is_attacking:
		move()
		try_attack()

func move():
	var normalize_diffe = var_diff.normalized() #Transforma o vetor apontando para o próximo ponto em um versor
	var input_vector = normalize_diffe 
	enemy.velocity = input_vector * speed * 100.0
	#Determinar qual animação será usada:
	if abs(var_diff.x) >= abs(var_diff.y):
		position_running = "side"
		animation_player.play("default")
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
	enemy.move_and_slide()
	
func make_path(): #Calcula e cria o melhor caminho até o jogador, desviando de obstáculos
	var player_position = GameManager.player_position
	nav_agent.target_position = player_position
	
func try_attack():
	var areas = dmg_area.get_overlapping_areas() #Detecta todas as áreas que estão dentro da área de dano do inimigo
	for area in areas:
		if area.is_in_group("JogadorHitBox"): #Detecta se alguma área detectada é um jogador
			enemy.attack()


func _on_timer_timeout():
	make_path()
