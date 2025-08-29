extends Bullet_base

var bullet_duracao = 0.8
var bullet_tempodevida = 0
var flecha:Node
@export var flecha_coletavel:PackedScene

func _ready():
	set_start_position()
	bullet_damage += GameManager.upgrade_besta[1]
	piercing += GameManager.upgrade_besta[0]
	
func _process(delta):
	bullet_tempodevida += delta
	if bullet_duracao < bullet_tempodevida:
		queue_free()
	
func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	hit_enemy(area)
	desapear_on_hit_building(area)


func _exit_tree() -> void:
	print_debug("cai")
	flecha = flecha_coletavel.instantiate()
	print_debug(flecha,global_position,get_parent())
	flecha.global_position = global_position
	if velocity.x >= 0:
		flecha.flip_h = true
	get_parent().add_child.call_deferred(flecha)
	print_debug("Eu deveria ter dropado a flecha")
