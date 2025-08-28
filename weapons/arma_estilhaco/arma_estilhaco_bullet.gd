extends Bullet_base

var numero_estilhacos:int = 4
@export var estilhacinho:PackedScene
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	set_start_position()
	bullet_damage += GameManager.upgrade_estilhaco[1]
	numero_estilhacos += GameManager.upgrade_estilhaco[2]
	
func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox") or area.is_in_group("construcao"):
		audio_player.play()
		dividir()
		hit_enemy(area)
		desapear_on_hit_building(area)

func dividir():
	var angle_offset = PI/numero_estilhacos
	for direction in range(0,numero_estilhacos):
		var sub = estilhacinho.instantiate()
		sub.bullet_damage = bullet_damage * 0.5
		get_parent().add_child(sub)
		sub.global_position = global_position
		sub.rotation = rotation + direction*2*PI/numero_estilhacos + angle_offset
	
	queue_free()
