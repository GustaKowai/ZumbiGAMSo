extends Bullet_base

func _ready():
	set_start_position()
	bullet_damage += GameManager.upgrade_revolver[1]
	piercing += GameManager.upgrade_revolver[2]
	
func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	hit_enemy(area)
	desapear_on_hit_building(area)
