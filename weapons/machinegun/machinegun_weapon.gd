extends Node2D

@onready var bullet_path = preload("res://weapons/machinegun/machine_gun_bullet.tscn")
@onready var player = get_parent()
@onready var animation_player = $AnimationPlayer
@onready var marker = $Marker2D
@onready var sprite = $Sprite2D
@export var weapon_cooldown = 0.1
@export var ammo = 100
@export var bullet_spreed = PI/10
@export var intervalo_entre_tiros = 5.0
@export var velocidade_tiros = 1.0
var interval = 0
var firing = false

func _ready() -> void:
	#print_debug("Pronto!")
	#Isso aqui é para a arma não aparecer no sprite quando for pega, apenas quando for usada
	sprite.visible = false
	#Envia para o gamemanager e para o player o cd da arma
	GameManager.weapon_cd = weapon_cooldown
	#Recebe o sinal de quando uma arma for coletada e conecta ele a função de largar a arma atual
	GameManager.weapon_collected.connect(on_weapon_collected)
	#Atualiza conforme o upgrade:
	bullet_spreed *= GameManager.upgrade_metralhadora[2]*1.0/100
	ammo += GameManager.upgrade_metralhadora[0]
	velocidade_tiros *= GameManager.upgrade_metralhadora[3]*1.0/100
	if GameManager.upgrade_metralhadora[4] == 1:
		bullet_path = preload("res://weapons/machinegun/machinegun_bullet_upgrade.tscn")
	#Envia para o GameManager a munição inicial da arma:
	GameManager.ammo = ammo

func on_weapon_collected(string): #Essa função serve para largar a arma
	#print_debug("larguei a arma")
	queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("FireGun"):
		fireGun()
	if Input.is_action_pressed("FireGun") and firing == true:
		interval += velocidade_tiros
		firing_animation()
		#print_debug(interval)
		if interval>=intervalo_entre_tiros:
			interval = 0
			player.weapon_cooldown = weapon_cooldown*1000
			player.is_shooting = true
			fire_bullet()
		
	if Input.is_action_just_released("FireGun"):
		player.weapon_cooldown = weapon_cooldown
		firing = false

func fireGun():
	if ammo <= 0:
		return
	#Checa se já está atacando:
	if player.is_attacking or player.is_shooting:
		return
	#Define como atacando:
	player.is_shooting = true
	player.weapon_cooldown = weapon_cooldown*1000
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

func firing_animation():
	if ammo <= 0:
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
	firing = true
