extends Bullet_base

var tempo_sem_dar_dano = 0.05

func _ready():
	set_start_position()
	
func _physics_process(delta):
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	move_and_slide()
	desapear_on_distance()

func _process(delta: float) -> void:
	tempo_sem_dar_dano -= delta

func _on_bullet_hit_box_area_entered(area):
	if tempo_sem_dar_dano > 0:
		return
	hit_enemy(area)
	desapear_on_hit_building(area)
