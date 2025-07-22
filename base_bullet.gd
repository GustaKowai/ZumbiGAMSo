class_name Bullet_base
extends CharacterBody2D

@export var bullet_hit_scene:PackedScene
@export var speed:int
@export var bullet_damage:int
@export var piercing:int = 0
var pos:Vector2
var rota:float
var dir: float

func set_start_position():
	global_position = pos
	global_rotation = rota
		
func move_front():
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	desapear_on_distance()
	
func desapear_on_distance():
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 5000000:
			queue_free()
	else:
		queue_free()

func hit_enemy(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		set_bullet_hit()
		if piercing <= 0:
			queue_free()
		piercing -= 1
		
func desapear_on_hit_building(area):
	if area.is_in_group("construcao"):
		set_bullet_hit()
		#print_debug("Acertei um predio")
		queue_free()

func set_bullet_hit():
	if bullet_hit_scene:
		var bullet_hit = bullet_hit_scene.instantiate()
		bullet_hit.global_position = global_position
		bullet_hit.global_rotation = global_rotation
		get_parent().get_parent().add_child(bullet_hit)
		
func knockback_enemy(area,time_knockback:float):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.follow.knockback(velocity,time_knockback)
