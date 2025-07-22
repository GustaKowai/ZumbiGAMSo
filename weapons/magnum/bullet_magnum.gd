extends Bullet_base


func _ready():
	set_start_position()

func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	hit_enemy(area)
	desapear_on_hit_building(area)
