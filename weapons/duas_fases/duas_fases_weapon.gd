extends Node2D

@onready var bullet_path_1:PackedScene = preload("res://weapons/duas_fases/primeira_fase_bullet.tscn")
@onready var bullet_path_2:PackedScene = preload("res://weapons/duas_fases/segunda_fase_bullet.tscn")
var bullet_path:PackedScene
@onready var player:Jogador = get_parent()
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var marker:Marker2D = $Marker2D
@onready var sprite:Sprite2D = $Sprite2D
@onready var charge_bar:TextureProgressBar = $TextureProgressBar
@onready var charge_animation:AnimatedSprite2D = $Marker2D/Charge_animation
@onready var firing_animation_machinegun: AnimatedSprite2D = $Marker2D/firing_animation_machinegun
@export var weapon_cooldown:float = 0.1
@export var ammo:int = 50
@export var bullet_spreed:float = PI/10
@export var fire_animation:PackedScene
var interval:float = 0
var firing:bool = false
var mode:int = 1
var bullet_interval:float = 10
var bullets_shooted:int:
	set(new_value):
		bullets_shooted = new_value
		charge_bar.value = bullets_shooted
var bullet_accel:float = 0

func _ready() -> void:
	#print_debug("Pronto!")
	#Isso aqui é para a arma não aparecer no sprite quando for pega, apenas quando for usada
	sprite.visible = false
	#Envia para o gamemanager e para o player o cd da arma
	GameManager.weapon_cd = weapon_cooldown
	#Recebe o sinal de quando uma arma for coletada e conecta ele a função de largar a arma atual
	GameManager.weapon_collected.connect(on_weapon_collected)
	#Envia para o GameManager a munição inicial da arma:
	ammo += GameManager.upgrade_duas_fases[0]
	GameManager.ammo = ammo

func on_weapon_collected(string): #Essa função serve para largar a arma
	#print_debug(string)
	if string == "res://weapons/duas_fases/Arma_fase_2.png" or string == "res://weapons/duas_fases/Arma_fase_1.png":
		return
	#print_debug("larguei a arma de duas fases")
	queue_free()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("FireGun"):
		mode = 1
		sprite.texture = load("res://weapons/duas_fases/Arma_primeira_fase-Sheet.png")
		bullets_shooted = 0
		bullet_accel = 0
		bullet_spreed = PI/12
		fireGun()
		bullet_path = bullet_path_1
		#fire_bullet()
	if Input.is_action_pressed("FireGun") and firing == true:
		if mode == 1:
			charge_animation.visible = true
			bullet_interval = 10 - bullet_accel
			firing_mode1()
			bullet_path = bullet_path_1
		if mode == 2:
			bullet_interval = 15
			bullet_path = bullet_path_2
		interval += 1
		bullet_accel += delta*4
		if interval>=bullet_interval:
			interval = 0
			#print_debug(bullet_interval)
			player.weapon_cooldown = weapon_cooldown*10000
			player.is_shooting = true
			fire_bullet()
			bullets_shooted += 1
			charge_animation.speed_scale = 1+bullets_shooted/15
			#print_debug(bullets_shooted)
			if bullets_shooted >= 30 and mode == 1:
				charge_animation.visible = false
				bullets_shooted = 20
				GameManager.weapon_collected.emit("res://weapons/duas_fases/Arma_fase_2.png")
				mode = 2
				sprite.texture = load("res://weapons/duas_fases/Arma_segunda_fase-Sheet.png")
				bullet_spreed = PI/24
		
	if Input.is_action_just_released("FireGun"):
		player.weapon_cooldown = weapon_cooldown
		if firing:
			animation_player.stop()
			charge_animation.visible = false
			firing_animation_machinegun.visible = false
			sprite.visible = false
			firing = false
			bullets_shooted = 0
			GameManager.weapon_collected.emit("res://weapons/duas_fases/Arma_fase_1.png")

func fireGun():
	if ammo <= 0:
		return
	#Checa se já está atacando:
	if player.is_attacking or player.is_shooting:
		return
	#Define como atacando:
	player.is_shooting = true
	player.weapon_cooldown = weapon_cooldown*10000
	#Determina a qual direção vai atacar e qual animação vai usar:
	if player.position_running == "down":
			animation_player.play("fire_down")
			player.sprite.flip_h = false
			player.animation_player.play("Fire_down")
	elif player.position_running == "up":
			animation_player.play("fire_up")
			player.sprite.flip_h = false
			player.animation_player.play("Fire_up")
	elif player.position_running == "side":
		if not player.sprite.flip_h:
			animation_player.play("fire_side_left")
			player.animation_player.play("Fire_side_left")
		if player.sprite.flip_h:
			animation_player.play("fire_side_right")	
			player.animation_player.play("Fire_side_right")
	

func firing_mode1():
	if ammo <= 0:
		animation_player.stop()
		return
	#Determina a qual direção vai atacar e qual animação vai usar:
	if player.position_running == "down":
			animation_player.play("firing_down")
			player.sprite.flip_h = false
			player.animation_player.play("firing down")
	elif player.position_running == "up":
			animation_player.play("firing_up")
			player.sprite.flip_h = false
			player.animation_player.play("firing up")
	elif player.position_running == "side":
		if not player.sprite.flip_h:
			animation_player.play("firing_side_left")
			player.animation_player.play("firing left")
		if player.sprite.flip_h:
			animation_player.play("firing_side_right")	
			player.animation_player.play("firing right")

func fire_bullet():
	#Determina a direção do tiro e cria a bala
	var bullet = bullet_path.instantiate()
	var bullet_deviation = randf_range(-bullet_spreed,bullet_spreed)
	if player.position_running == "down":
			bullet.dir = PI/2 + bullet_deviation
			bullet.pos = marker.global_position
			bullet.rota = PI/2 + bullet_deviation
	elif player.position_running == "up":
			bullet.dir = -PI/2 + bullet_deviation
			bullet.pos = marker.global_position
			bullet.rota = -PI/2 + bullet_deviation
	elif player.position_running == "side":
		if not player.sprite.flip_h:
			bullet.dir = PI + bullet_deviation
			bullet.pos = marker.global_position
			bullet.rota = PI + bullet_deviation
		if player.sprite.flip_h:
			bullet.dir = 0 + bullet_deviation
			bullet.pos = marker.global_position
			bullet.rota = 0 + bullet_deviation
	get_parent().get_parent().add_child(bullet)#Instancia a bala
	ammo -= 1
	GameManager.ammo = ammo
	if ammo == 0:
		player.weapon_cooldown = weapon_cooldown
		firing = false
		queue_free() #Solta a arma se ficar sem munição

func set_firing():
	if Input.is_action_pressed("FireGun"): 
		firing_animation_machinegun.visible = true
		firing = true
	

func firing_animation_play():
	if fire_animation:
		var firing_effect = fire_animation.instantiate()
		if player.position_running == "down":
				firing_effect.pos = marker.global_position
				firing_animation_machinegun.rotation = PI/2
				firing_effect.rota = PI/2
		elif player.position_running == "up":
				firing_effect.pos = marker.global_position
				firing_animation_machinegun.rotation = -PI/2
				firing_effect.rota = -PI/2
		elif player.position_running == "side":
			if not player.sprite.flip_h:
				firing_effect.pos = marker.global_position
				firing_animation_machinegun.rotation = PI
				firing_effect.rota = PI
			if player.sprite.flip_h:
				firing_effect.pos = marker.global_position
				firing_animation_machinegun.rotation = 0
				firing_effect.rota = 0
		get_parent().add_child(firing_effect)#Instancia a bala
