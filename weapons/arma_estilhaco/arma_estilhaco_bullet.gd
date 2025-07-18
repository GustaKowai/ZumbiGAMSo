extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed:int = 650
var bullet_damage:int = 16
var piercing = 0
@export var estilhacinho:PackedScene
@export var bullet_hit_scene:PackedScene

func _ready():
	global_position = pos
	global_rotation = rota
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 1000000:
			queue_free()
	else:
		queue_free()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		set_bullet_hit()
		var enemy_position = enemy.global_position
		dividir()
		if piercing <= 0:
			queue_free()
		piercing -= 1
	if area.is_in_group("construcao"):
		set_bullet_hit()
		dividir()
		queue_free()

func dividir():
	var angle_offset = deg_to_rad(45)
	for direction in [1, 3, 5, 7]:
		var sub = estilhacinho.instantiate()
		sub.bullet_damage = bullet_damage * 0.5
		get_parent().add_child(sub)
		sub.global_position = global_position
		sub.rotation = rotation + angle_offset * direction
	
	queue_free()
	
func set_bullet_hit():
	if bullet_hit_scene:
		var bullet_hit = bullet_hit_scene.instantiate()
		bullet_hit.global_position = global_position
		bullet_hit.global_rotation = global_rotation
		get_parent().get_parent().add_child(bullet_hit)
