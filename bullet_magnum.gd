extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed = 2000
var bullet_damage = 26

func _ready():
	global_position = pos
	global_rotation = rota

func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		#queue_free()
