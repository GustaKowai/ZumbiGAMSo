extends Node2D

@onready var bullet_path = preload("res://weapons/revolver/bullet.tscn")
@onready var player = get_parent()
@onready var animation_player = $AnimationPlayer
@onready var marker = $Marker2D
@onready var sprite = $Sprite2D
@export var weapon_cooldown = 0.3
@export var ammo = 6
var upgrade = false

func _ready() -> void:
	#print("Pronto!")
	#Isso aqui é para a arma não aparecer no sprite quando for pega, apenas quando for usada
	sprite.visible = false
	#Envia para o gamemanager e para o player o cd da arma
	GameManager.weapon_cd = weapon_cooldown
	#Recebe o sinal de quando uma arma for coletada e conecta ele a função de largar a arma atual
	GameManager.weapon_collected.connect(on_weapon_collected)
	#Envia para o GameManager a munição inicial da arma:
	ammo += GameManager.upgrade_revolver[0]
	GameManager.ammo = ammo
	if GameManager.upgrade_revolver[3] == 1:
		bullet_path = preload("res://weapons/revolver/bullet_curva.tscn")
		upgrade = true

func on_weapon_collected(string): #Essa função serve para largar a arma
	print("larguei a arma")
	queue_free()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("FireGun"): #Agora a checagem se o player tentou atirar acontece aqui
		if not (player.is_attacking or player.is_shooting):
			fireGun()

func fireGun():
	#Checa se já está atacando:
	if player.is_attacking or player.is_shooting:
		return
	else:
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
			print(player.is_shooting)
			if not player.sprite.flip_h:
				animation_player.play("fire_side_left")
				player.animation_player.play("Fire_side_left")
			if  player.sprite.flip_h:
				animation_player.play("fire_side_right")
				player.animation_player.play("Fire_side_right")

func fire_bullet():
	if ammo <= 0: queue_free()
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
	ammo -= 1
	GameManager.ammo = ammo
	#print(ammo)
	if ammo <= 0:
		queue_free() #Solta a arma se ficar sem munição

func fire_n_bullet():
	fire_bullet()
	if upgrade and ammo > 0: fire_bullet()

func print_message():
	print("Enviei a mensagem")
