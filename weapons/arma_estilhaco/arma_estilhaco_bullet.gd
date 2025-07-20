extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed:int = 650
var bullet_damage:int = 16
var piercing:int = 0
var numero_estilhacos:int = 4
@export var estilhacinho:PackedScene
@export var bullet_hit_scene:PackedScene

func _ready():
	global_position = pos
	global_rotation = rota
	bullet_damage += GameManager.upgrade_estilhaco[1]
	numero_estilhacos += GameManager.upgrade_estilhaco[2]
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
	var angle_offset = PI/numero_estilhacos
	for direction in range(0,numero_estilhacos):
		var sub = estilhacinho.instantiate()
		sub.bullet_damage = bullet_damage * 0.5
		get_parent().add_child(sub)
		sub.global_position = global_position
		sub.rotation = rotation + direction*2*PI/numero_estilhacos + angle_offset
	
	queue_free()
	
func set_bullet_hit():
	if bullet_hit_scene:
		var bullet_hit = bullet_hit_scene.instantiate()
		bullet_hit.global_position = global_position
		bullet_hit.global_rotation = global_rotation
		get_parent().get_parent().add_child(bullet_hit)
