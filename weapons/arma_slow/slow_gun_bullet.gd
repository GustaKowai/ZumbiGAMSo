extends Bullet_base
@export var multipicador_vel:float = 0.5 #Essa variavel vai multiplicar a velocidade do zumbi para diminui-la
@export var slow_effect:PackedScene

func _ready():
	set_start_position()
	bullet_damage+= GameManager.upgrade_slow[1]
	
func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	apply_slow(area)
	hit_enemy(area)
	desapear_on_hit_building(area)
	
func apply_slow(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		if not enemy.is_in_group("tanque"):
			enemy.modulate = Color.GOLDENROD
			var slow = slow_effect.instantiate()
			enemy.add_child(slow)
			var zombie_movement = enemy.get_node("FollowPlayer")
			zombie_movement.speed *= multipicador_vel
