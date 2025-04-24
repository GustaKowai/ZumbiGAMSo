class_name Jogador_teste1
extends CharacterBody2D
@onready var _animated_sprite = $AnimatedSprite2D

@export_category("Movement")
@export var speed = 3.0
@export_range(0,1) var lerp_smoothness = 0.5

var input_vector = Vector2(0,0)
var position_running = "down"
var atk_direction: Vector2
var is_attacking = false
var attack_cooldown = 0.0

func _process(delta):
	#Obtem o vetor de input:	
	input_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	play_run_iddle()
	rotate_sprite()
	
	#Atualiza o cd do atk
	update_atk_cd(delta)
	#Executa o ataque:
	if Input.is_action_just_pressed("attack"):
		attack()

func _physics_process(delta):
	var target_velocity = input_vector*speed*100.0
	if is_attacking:
		target_velocity *= 0.1
	velocity = lerp(velocity,target_velocity,lerp_smoothness)
	move_and_slide()
	
#Funções de movimento:	
func play_run_iddle():
	#Checa se o personagem está atacando:
	if not is_attacking:	
		#Checa se o personagem está correndo
		if input_vector.is_zero_approx():
			if position_running == "down":
				_animated_sprite.play("Idle Down")
			elif position_running == "up":
				_animated_sprite.play("Idle Up")
			elif position_running == "side":
				_animated_sprite.play("Idle Side") 	
		else:
			if abs(input_vector.x) >= abs(input_vector.y):
				position_running = "side"
				_animated_sprite.play("Move Side")
			elif input_vector.y > 0:
				position_running = "down"
				_animated_sprite.play("Move Down")
			else:
				position_running = "up"
				_animated_sprite.play("Move Up")


func rotate_sprite():
	#girar sprite:
	if not is_attacking:
		if input_vector.x > 0:
			_animated_sprite.flip_h = false
		elif input_vector.x <0:
			_animated_sprite.flip_h = true
				
func update_atk_cd(delta):
	if is_attacking:
		attack_cooldown -=delta
		if attack_cooldown <=0:
			is_attacking = false
			
func attack():
	#Checa se já está atacando:
	if is_attacking:
		return
	#Define como atacando:
	is_attacking = true
	attack_cooldown = 0.6
	
	if _animated_sprite.flip_h:
		atk_direction = Vector2.LEFT
		_animated_sprite.play("Atk Side")
	if not _animated_sprite.flip_h:
		atk_direction = Vector2.RIGHT
		_animated_sprite.play("Atk Side")
