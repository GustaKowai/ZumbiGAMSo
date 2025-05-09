class_name Jogador
extends CharacterBody2D

const PHANTON_YELLOW = Color(1, 1, 0, 0.5)
const PHANTON_RED = Color(1, 0, 0, 0.5)
const PHANTON_GREEN = Color(0, 1, 0, 0.5)

@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprites/Player
@onready var sprite_weapon =  $Sprites/Weapon
@onready var sword_area = $SwordArea
@onready var hitbox_area = $HitBoxArea
@onready var health_progress_bar = $HealthBar
@onready var style = health_progress_bar.get_theme_stylebox("fill") as StyleBoxFlat
@onready var equiped_weapon = $Sprites/Weapon

@export_category("Movement")
@export var speed = 3.0
@export_range(0,1) var lerp_smoothness = 0.5

@export_category("Combat")
@export var max_health = 20
@export var sword_damage:int = 20
@export var ammo:int = 0
var player_health = max_health
@export var death_prefab:PackedScene

var input_vector = Vector2(0,0)
var position_running = "down"
var atk_direction: Vector2
var is_attacking = false
var attack_cooldown = 0.0
var bullet_path = null
var weapon_path = null
var weapon_cooldown = null

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
	#Atualiza a barra de vida:
	update_health_bar()
	#Atualiza o cd do atk
	update_atk_cd(delta)
	#Executa o ataque:
	if Input.is_action_just_pressed("attack"):
		attack()
	if Input.is_action_just_pressed("FireGun"):
		fireGun()

func _physics_process(_delta):
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
			sprite_weapon.flip_h = false
		elif input_vector.x <0:
			sprite.flip_h = true
			sprite_weapon.flip_h = true

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
	var areas = sword_area.get_overlapping_areas()#Detecta áreas dentro da área de dano da espada
	for area in areas:
		if area.is_in_group("EnemyHitBox"):#Identifica se alguma área é um inimigo
			var enemy:Enemy  = area.get_parent()
			var enemy_direction = (enemy.position - position).normalized()
			var dot_product = enemy_direction.dot(atk_direction)
			if dot_product > 0.3: #Verifica se o jogador está virado para o inimigo
				enemy.damage(sword_damage)
	#var bodies = sword_area.get_overlapping_bodies()
	

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
	
	if player_health <=0:
		die()
	
func fireGun():
	if ammo <= 0 or not bullet_path or not weapon_path:#Se acabar as balas ou estiver sem arma, não faz nada
		return
	var bullet = bullet_path.instantiate()
	#Checa se já está atacando:
	if is_attacking:
		return
	#Define como atacando:
	is_attacking = true
	attack_cooldown = weapon_cooldown
	#Determina a direção do tiro:
	if position_running == "down":
			animation_player.play("Fire_down")
			bullet.dir = PI/2
			bullet.pos.x = $ShootPosition.global_position.x
			bullet.pos.y = $ShootPosition.global_position.y +100
			bullet.rota = PI/2
	elif position_running == "up":
			animation_player.play("Fire_up")
			bullet.dir = -PI/2
			bullet.pos = $ShootPosition.global_position
			bullet.pos.y = $ShootPosition.global_position.y -50
			bullet.rota = -PI/2
	elif position_running == "side":
		if sprite.flip_h:
			animation_player.play("Fire_side_left")
			bullet.dir = PI
			bullet.pos = $ShootPosition.global_position
			bullet.pos.x = $ShootPosition.global_position.x -50
			bullet.rota = PI
		if not sprite.flip_h:
			animation_player.play("Fire_side_right")
			bullet.dir = 0
			bullet.pos = $ShootPosition.global_position
			bullet.pos.x = $ShootPosition.global_position.x + 50
			bullet.rota = 0
	
	get_parent().add_child(bullet)#Instancia a bala
	ammo -= 1
	print(ammo)
	if ammo == 0:
		#Remove a arma se ficar sem munição
		bullet_path = null 
		weapon_path = null 
		weapon_cooldown = null
		
func update_health_bar():
	health_progress_bar.max_value = max_health
	health_progress_bar.value = player_health
	var player_relative_health = player_health*1.0/max_health*1.0
	if player_relative_health > 0.5:
		style.bg_color = PHANTON_YELLOW.lerp(PHANTON_GREEN, (player_relative_health-0.5)*2)
	else:
		style.bg_color = PHANTON_RED.lerp(PHANTON_YELLOW, player_relative_health*2)

func die():
	GameManager.end_game()
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()
