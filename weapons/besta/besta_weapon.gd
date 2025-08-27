extends Node2D

@onready var bullet_path = preload("res://weapons/revolver/bullet.tscn")
@onready var player = get_parent()
@onready var animation_player = $AnimationPlayer
@onready var marker = $Marker2D
@onready var sprite = $Sprite2D
@export var weapon_cooldown = 0.3
@export var ammo = 1
@export var fire_animation:PackedScene
var upgrade = false

func _ready() -> void:
	sprite.visible = false
	GameManager.weapon_cd = weapon_cooldown
	GameManager.weapon_collected.connect(on_weapon_collected)
	#ammo += GameManager.upgrade_shotgun[0]
	GameManager.ammo = ammo

func on_weapon_collected(string):
	queue_free()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("FireGun"):
		if not (player.is_attacking or player.is_shooting):
			fireGun()

func fireGun():
	if player.is_attacking or player.is_shooting:
		return
	else:
		player.weapon_cooldown = weapon_cooldown
		player.is_shooting = true
		AudioController.play_shoot()
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
			if  player.sprite.flip_h:
				animation_player.play("fire_side_right")
				player.animation_player.play("Fire_side_right")

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
		if not player.sprite.flip_h:
			bullet.dir = PI
			bullet.pos = marker.global_position
			bullet.rota = PI
		if player.sprite.flip_h:
			bullet.dir = 0
			bullet.pos = marker.global_position
			bullet.rota = 0
	get_parent().get_parent().add_child(bullet)#Instancia a bala
	firing_animation_play()
	ammo -= 1
	GameManager.ammo = ammo
	#print_debug(ammo)
	if ammo == 0:
		queue_free() #Solta a arma se ficar sem munição


func print_message():
	pass
	#print_debug("Enviei a mensagem")
	
func firing_animation_play():
	if fire_animation:
		var firing = fire_animation.instantiate()
		if player.position_running == "down":
				firing.pos = marker.global_position
				firing.rota = PI/2
		elif player.position_running == "up":
				firing.pos = marker.global_position
				firing.rota = -PI/2
		elif player.position_running == "side":
			if not player.sprite.flip_h:
				firing.pos = marker.global_position
				firing.rota = PI
			if player.sprite.flip_h:
				firing.pos = marker.global_position
				firing.rota = 0
		get_parent().get_parent().add_child(firing)#Instancia a bala
