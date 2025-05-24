extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed = 500
var bullet_damage = 50

func _ready():
	global_position = pos
	global_rotation = rota

func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	if position.distance_squared_to(GameManager.player.position) > 1000000:
		queue_free()

func _on_segunda_fase_bullet_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		#queue_free()
	if area.is_in_group("construcao"):
		print("Acertei um predio")
		queue_free()
