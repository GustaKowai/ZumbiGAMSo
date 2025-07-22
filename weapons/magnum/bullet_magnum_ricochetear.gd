extends Bullet_base


func _ready():
	set_start_position()

func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		set_bullet_hit()
		#queue_free()
	if area.is_in_group("construcao"):
		set_bullet_hit()
		#tentativa de criar o ricochete em prédios
		velocity = Vector2(speed,PI).rotated(PI)*2
		move_and_slide()
