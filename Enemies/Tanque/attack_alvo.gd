extends Node2D
@onready var bullet_point:Marker2D = $BulletPoint
@export var bullet_path:PackedScene
@export var controle_de_buff_de_dano:float
var dano_extra_zombie = 0
var enemy: Enemy
var sprite:Sprite2D
var animation_player:AnimationPlayer
var var_diff:Vector2
var player:Jogador
var attack_cooldown:float
@export var atk_cd:float = 1.5
@export var range = 200
@export var accuracy = 30
var shoot_direction:String
@export var alvo_scene:PackedScene
var ID_tiro:int = 0
var modo_metralhadora:float = false

func _ready():
	enemy = get_parent()
	sprite =enemy.get_node("Movimento")
	animation_player = enemy.get_node("AnimationPlayer")
	dano_extra_zombie += snappedi(controle_de_buff_de_dano*enemy.buff,1)
	#print_debug("Dano extra do tiro desse zumbi = ",dano_extra_zombie) 
	player = GameManager.player

func _process(delta: float) -> void:
	try_shoot()
	update_atk_cd(delta)
	

func update_atk_cd(delta):
	if enemy.is_attacking:
		attack_cooldown -=delta
		if attack_cooldown <=0:
			enemy.is_attacking = false

func try_shoot():
	if player:
		if enemy.is_attacking:return
		var player_position = player.global_position
		if GameManager.is_taunting:
			player_position = GameManager.taunt_position
		var point_weapon:Vector2 = player_position - enemy.global_position
		if point_weapon.length_squared() >= range*1000: return
		if modo_metralhadora:
			pass
		else:
			if point_weapon.x <= accuracy/4 and point_weapon.x >= -accuracy/4:
				if point_weapon.y < 0:
					shoot_direction = "Up"
					shoot()
				else:
					shoot_direction = "Down"
					shoot()
			if point_weapon.y <=accuracy and point_weapon.y >= 0:
				#print_debug(point_weapon.y)
				if point_weapon.x > 0:
					shoot_direction = "Right"
					shoot()
				else:
					shoot_direction = "Left"
					shoot()
				
func shoot():
	if enemy.is_attacking:return
	enemy.is_attacking = true
	attack_cooldown = atk_cd
	match shoot_direction:
		"Up":
			animation_player.play("Fire Up Cannon")
		"Down":
			animation_player.play("Fire Down Cannon")
		"Left":
			animation_player.play("Fire Left Cannon")
		"Right":
			animation_player.play("Fire Right Cannon")

func fire_bullet():
	var bullet = bullet_path.instantiate()
	bullet.ID = ID_tiro
	bullet.bullet_damage += dano_extra_zombie
	match shoot_direction:
		"Down":
			bullet.dir = PI/2
			bullet.pos = bullet_point.global_position
			bullet.rota = PI/2
		"Up":
			bullet.dir = -PI/2
			bullet.pos = bullet_point.global_position
			bullet.rota = -PI/2
		"Left":
			bullet.dir = PI
			bullet.pos = bullet_point.global_position
			bullet.rota = PI
		"Right":
			bullet.dir = 0
			bullet.pos = bullet_point.global_position
			bullet.rota = 0
	get_parent().get_parent().add_child(bullet)#Instancia a bala

func mirar():
	var posicao_alvo = GameManager.player_position
	var alvo = alvo_scene.instantiate()
	ID_tiro = randi()
	alvo.ID = ID_tiro
	alvo.global_position = posicao_alvo
	get_parent().get_parent().add_child(alvo)
