class_name Jogador
extends CharacterBody2D
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var sword_area = $SwordArea
@onready var hitbox_area = $HitBoxArea

@export_category("Movement")
@export var speed = 3.0
@export_range(0,1) var lerp_smoothness = 0.5
@export var player_health = 20

@export_category("Combat")
@export var sword_damage:int = 20
@export var ammo:int = 0

var input_vector = Vector2(0,0)
var position_running = "down"
var atk_direction: Vector2
var is_attacking = false
var attack_cooldown = 0.0
var bullet_path = null

func _ready():
	#Passa o player para o GameManager
	GameManager.player = self

func _process(delta):
	#Passa a informação da posição do player para o Game Manager
	GameManager.player_position = position
	#Obtem o vetor de input:	
	input_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	play_run_iddle()
	rotate_sprite()
	
	#Atualiza o cd do atk
	update_atk_cd(delta)
	#Executa o ataque:
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("FireGun"):
		fireGun()

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
				animation_player.play("Idle Down")
			elif position_running == "up":
				animation_player.play("Idle Up")
			elif position_running == "side":
				animation_player.play("Idle Side") 	
		else:
			if abs(input_vector.x) >= abs(input_vector.y):
				position_running = "side"
				animation_player.play("Move Side")
			elif input_vector.y > 0:
				position_running = "down"
				animation_player.play("Move Down")
			else:
				position_running = "up"
				animation_player.play("Move Up")

func rotate_sprite():
	#girar sprite:
	if not is_attacking:
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x <0:
			sprite.flip_h = true

#Funções de ataque
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
	
	if position_running == "down":
		animation_player.play("Atk Down")
		atk_direction = Vector2.DOWN
	elif position_running == "up":
		animation_player.play("Atk Up")
		atk_direction = Vector2.UP
	elif position_running == "side":
		animation_player.play("Atk Side") 	
		if sprite.flip_h:
			atk_direction = Vector2.LEFT
		if not sprite.flip_h:
			atk_direction = Vector2.RIGHT
	
func deal_damage_to_enemies():
	var areas = sword_area.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("EnemyHitBox"):
			var enemy:Enemy  = area.get_parent()
			var enemy_direction = (enemy.position - position).normalized()
			var dot_product = enemy_direction.dot(atk_direction)
			print(dot_product)
			if dot_product > 0.3:
				enemy.damage(sword_damage)
	var bodies = sword_area.get_overlapping_bodies()
	

func damage(amount:int):
	if player_health <= 0:
		return
	player_health -=amount
	print("Player recebeu dano de ",amount,". A vida atual é de ",player_health,"/")
	#piscar o player:
	modulate = Color.ORANGE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
func fireGun():
	if ammo <= 0 or not bullet_path:
		return
	var bullet = bullet_path.instantiate()
	if position_running == "down":
			bullet.dir = PI/2
			bullet.pos.x = $ShootPosition.global_position.x
			bullet.pos.y = $ShootPosition.global_position.y +100
			bullet.rota = PI/2
	elif position_running == "up":
			bullet.dir = -PI/2
			bullet.pos = $ShootPosition.global_position
			bullet.pos.y = $ShootPosition.global_position.y -50
			bullet.rota = -PI/2
	elif position_running == "side":
		if sprite.flip_h:
			bullet.dir = PI
			bullet.pos = $ShootPosition.global_position
			bullet.pos.x = $ShootPosition.global_position.x -50
			bullet.rota = PI
		if not sprite.flip_h:
			bullet.dir = 0
			bullet.pos = $ShootPosition.global_position
			bullet.pos.x = $ShootPosition.global_position.x + 50
			bullet.rota = 0
	
	get_parent().add_child(bullet)
	ammo -= 1
	print(ammo)
	if ammo == 0:
		bullet_path = null
