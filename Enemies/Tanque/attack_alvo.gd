extends Node2D
@onready var bullet_point:Marker2D = $BulletPoint
@export var bullet_path:PackedScene
@export var machinegun_bullet:PackedScene
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
var modo_metralhadora:bool = false
var end_shooting_in_progress:bool = false

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
	if modo_metralhadora:
		machinegun_aim()
	

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


func _on_machinegun_start_body_entered(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		#print_debug("Jogador entrou")
		if modo_metralhadora:return
		enemy.is_attacking = true
		attack_cooldown = 10000
		match shoot_direction:
			"Up":
				animation_player.play("Fire Up Start")
			"Down":
				animation_player.play("Fire Down Start")
			"Left":
				animation_player.play("Fire Left Start")
			"Right":
				animation_player.play("Fire Right Start")


func _on_machinegun_end_body_exited(body: Node2D) -> void:
	if body.is_in_group("Jogador"):
		#print_debug("Jogador saiu")
		end_shooting_in_progress = true
		if modo_metralhadora:
			match shoot_direction:
				"Up":
					animation_player.play("Fire Up end")
				"Down":
					animation_player.play("Fire Down end")
				"Left":
					animation_player.play("Fire Left end")
				"Right":
					animation_player.play("Fire Right end")

func machinegun_aim():
	if end_shooting_in_progress:return
	if player:
		var player_position = player.global_position
		if GameManager.is_taunting:
			player_position = GameManager.taunt_position
		var point_weapon:Vector2 = player_position - enemy.global_position
		if abs(point_weapon.x) > abs(point_weapon.y):
			if point_weapon.x > 0:
				if shoot_direction != "Right":
					shoot_direction = "Right"
					animation_player.play("Fire Right shoot")
			else:
				if shoot_direction != "Left":
					shoot_direction = "Left"
					animation_player.play("Fire Left shoot")
		if abs(point_weapon.y) > abs(point_weapon.x):
			if point_weapon.y < 0:
				if shoot_direction != "Up":
					shoot_direction = "Up"
					animation_player.play("Fire Up shoot")
			else:
				if shoot_direction != "Down":
					shoot_direction = "Down"
					animation_player.play("Fire Down shoot")
					
func machinegun_shoot():
	var player_position:Vector2
	if player:
		player_position = player.global_position
		player_position.y -= 44.0
		if GameManager.is_taunting:
			player_position = GameManager.taunt_position
	else: return
	var local_target = player_position-global_position
	var bullet = machinegun_bullet.instantiate()
	bullet.dir = Vector2.RIGHT.angle_to(local_target)
	bullet.pos = bullet_point.global_position
	bullet.rota = Vector2.RIGHT.angle_to(local_target)
	bullet.bullet_damage = 1
	get_tree().get_root().get_node("Node2D").add_child(bullet)#Instancia a bala

func start_shooting():
	modo_metralhadora = true
	match shoot_direction:
				"Up":
					animation_player.play("Fire Up shoot")
				"Down":
					animation_player.play("Fire Down shoot")
				"Left":
					animation_player.play("Fire Left shoot")
				"Right":
					animation_player.play("Fire Right shoot")

func end_shooting():
	end_shooting_in_progress = false
	attack_cooldown = 0
	modo_metralhadora = false
