extends Node2D
@onready var bullet_point:Marker2D = $BulletPoint
@export var bullet_path:PackedScene
var enemy: Enemy
var sprite:Sprite2D
var animation_player:AnimationPlayer
var var_diff:Vector2
var player:Jogador
var attack_cooldown:float
var atk_cd:float = 0.7
@export var range = 200
@export var accuracy = 30
var shoot_direction:String
func _ready():
	enemy = get_parent()
	sprite =enemy.get_node("Movimento")
	animation_player = enemy.get_node("AnimationPlayer")
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
		if point_weapon.x <= accuracy and point_weapon.x >= -accuracy:
			if point_weapon.y < 0:
				shoot_direction = "Up"
				shoot()
			else:
				shoot_direction = "Down"
				shoot()
		if point_weapon.y <=accuracy and point_weapon.y >= -accuracy:
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
			animation_player.play("Fire Up")
		"Down":
			animation_player.play("Fire Down")
		"Left":
			animation_player.play("Fire Left")
		"Right":
			animation_player.play("Fire Right")

func fire_bullet():
	var bullet = bullet_path.instantiate()
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
