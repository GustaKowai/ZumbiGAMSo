extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed:int = 2000
var bullet_damage:int = 20
var piercing = 0

func _ready():
	global_position = pos
	global_rotation = rota
	bullet_damage += GameManager.upgrade_revolver[1]
	piercing += GameManager.upgrade_revolver[2]
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
		if piercing <= 0:
			queue_free()
		piercing -= 1
	if area.is_in_group("construcao"):
		#print("Acertei um predio")
		queue_free()
