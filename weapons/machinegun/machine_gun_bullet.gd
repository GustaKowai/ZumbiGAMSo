extends Bullet_base

func _ready():
	set_start_position()
	bullet_damage += GameManager.upgrade_metralhadora[1]

func _physics_process(delta):
	move_front()
	
func _on_machinegun_bullet_hit_box_area_entered(area: Area2D) -> void:
	hit_enemy(area)
	desapear_on_hit_building(area)
