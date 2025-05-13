extends Node2D

@onready var bullet_path = preload("res://weapons/bullet.tscn")
@onready var player = get_parent()
@onready var animation_player = $AnimationPlayer
@onready var marker = $Marker2D
@onready var sprite = $Sprite2D
@export var weapon_cooldown = 0.2
@export var ammo = 6

func _ready() -> void:
	print("Pronto!")
	sprite.visible = false
	GameManager.weapon_collected.connect(on_weapon_collected)
	GameManager.ammo = ammo

func on_weapon_collected():
	#print("larguei a arma")
	queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("FireGun"):
		fireGun()

func fireGun():
	if ammo <= 0:
		return
	#Checa se já está atacando:
	if player.is_attacking:
		return
	#Define como atacando:
	player.is_attacking = true
	player.attack_cooldown = weapon_cooldown
	#Determina a qual direção vai atacar e qual animação vai usar:
	if player.position_running == "down":
			animation_player.play("Fire_down")
	elif player.position_running == "up":
			animation_player.play("Fire_up")
	elif player.position_running == "side":
		if player.sprite.flip_h:
			animation_player.play("Fire_side_left")
		if not player.sprite.flip_h:
			animation_player.play("fire_side_right")	

func fire_bullet():
	#Determina a direção do tiro e cria a bala
	var bullet = bullet_path.instantiate()
	if player.position_running == "down":
			bullet.dir = PI/2
			bullet.pos = marker.global_position
			bullet.rota = PI/2
	elif player.position_running == "up":
			bullet.dir = -PI/2
			bullet.pos = marker.global_position
			bullet.rota = -PI/2
	elif player.position_running == "side":
		if player.sprite.flip_h:
			bullet.dir = PI
			bullet.pos = marker.global_position
			bullet.rota = PI
		if not player.sprite.flip_h:
			bullet.dir = 0
			bullet.pos = marker.global_position
			bullet.rota = 0
	get_parent().get_parent().add_child(bullet)#Instancia a bala
	ammo -= 1
	GameManager.ammo = ammo
	print(ammo)
	if ammo == 0:
		queue_free()
