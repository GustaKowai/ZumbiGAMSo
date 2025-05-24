extends Node2D

@onready var bullet_path_1:PackedScene = preload("res://weapons/duas_fases/primeira_fase_bullet.tscn")
@onready var bullet_path_2:PackedScene = preload("res://weapons/duas_fases/segunda_fase_bullet.tscn")
@onready var player:Jogador = get_parent()
@onready var animation_player:AnimationPlayer = $AnimationPlayer
@onready var marker:Marker2D = $Marker2D
@onready var sprite:Sprite2D = $Sprite2D
@export var weapon_cooldown:float = 0.1
@export var ammo:int = 50
@export var bullet_spreed:float = PI/10
var interval:float = 0
var firing:bool = false
var mode:int = 1
var bullet_interval:float = 10
var bullets_shooted:int = 0

func _ready() -> void:
	#print("Pronto!")
	#Isso aqui é para a arma não aparecer no sprite quando for pega, apenas quando for usada
	sprite.visible = false
	#Envia para o gamemanager e para o player o cd da arma
	GameManager.weapon_cd = weapon_cooldown
	#Recebe o sinal de quando uma arma for coletada e conecta ele a função de largar a arma atual
	GameManager.weapon_collected.connect(on_weapon_collected)
	#Envia para o GameManager a munição inicial da arma:
	GameManager.ammo = ammo

func on_weapon_collected(string): #Essa função serve para largar a arma
	#print("larguei a arma")
	queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("FireGun"):
		mode = 1
		bullets_shooted = 0
		bullet_spreed = PI/10
		fireGun()
		fire_bullet(bullet_path_1)
	if Input.is_action_pressed("FireGun") and firing == true:
		var bullet_path:PackedScene
		if mode == 1:
			bullet_interval = 10
			bullet_path = bullet_path_1
		if mode == 2:
			bullet_interval = 15
			bullet_path = bullet_path_2
		interval += 1
		if interval>=bullet_interval:
			interval = 0
			player.weapon_cooldown = weapon_cooldown
			player.is_shooting = true
			fire_bullet(bullet_path)
			bullets_shooted += 1
			print(bullets_shooted)
			if bullets_shooted > 30:
				mode = 2
				bullet_spreed = PI/5
		
	if Input.is_action_just_released("FireGun"):
		firing = false

func fireGun():
	if ammo <= 0:
		return
	#Checa se já está atacando:
	if player.is_attacking or player.is_shooting:
		return
	#Define como atacando:
	player.is_shooting = true
	player.weapon_cooldown = weapon_cooldown
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
		if player.sprite.flip_h:
			animation_player.play("fire_side_left")
			player.animation_player.play("Fire_side_left")
		if not player.sprite.flip_h:
			animation_player.play("fire_side_right")	
			player.animation_player.play("Fire_side_right")

func fire_bullet(bullet_path):
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
		if player.sprite.flip_h:
			bullet.dir = PI + bullet_deviation
			bullet.pos = marker.global_position
			bullet.rota = PI + bullet_deviation
		if not player.sprite.flip_h:
			bullet.dir = 0 + bullet_deviation
			bullet.pos = marker.global_position
			bullet.rota = 0 + bullet_deviation
	get_parent().get_parent().add_child(bullet)#Instancia a bala
	ammo -= 1
	GameManager.ammo = ammo
	if ammo == 0:
		firing = false
		queue_free() #Solta a arma se ficar sem munição

func set_firing():
	firing = true
