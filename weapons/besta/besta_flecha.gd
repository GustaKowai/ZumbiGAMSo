extends Bullet_base

var bullet_duracao = 0.8
var bullet_tempodevida = 0

func _ready():
	set_start_position()
	#bullet_damage += GameManager.upgrade_shotgun[1]
	#bullet_duracao*= GameManager.upgrade_shotgun[3]*1.0/100
	
#Tentativa de fazer as balas desaparecerem depois de um tempo
func _process(delta):
	bullet_tempodevida += delta
	if bullet_duracao < bullet_tempodevida:
		queue_free()
		
		
func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	hit_enemy(area)
	desapear_on_hit_building(area)
	knockback_enemy(area,0.2)
	



func _on_tree_exited() -> void:
	pass
