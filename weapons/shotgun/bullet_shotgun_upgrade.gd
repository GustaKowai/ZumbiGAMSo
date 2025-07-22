extends Bullet_base

@export var bullet_duracao = 0.48
@export var bullet_ghost:PackedScene
var bullet_tempodevida = 0
var inversao_direcao = 1
var ghost_color = 0
var ghost_timer = Timer.new()
var ida_volta = 1

func _ready():
	set_start_position()
	bullet_damage += GameManager.upgrade_shotgun[1]
	bullet_duracao*= GameManager.upgrade_shotgun[3]*1.0/100
	set_ghosts()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self,"speed",-speed, bullet_duracao)
	
func _process(delta):
	bullet_tempodevida += delta
	if bullet_tempodevida > bullet_duracao:
		queue_free()
	
func _physics_process(delta):
	move_front()

func _on_bullet_hit_box_area_entered(area):
	hit_enemy(area)
	desapear_on_hit_building(area)

func set_ghosts():
	#Efeitos visuais de fantasma:
	add_child(ghost_timer)
	ghost_timer.wait_time = bullet_duracao/14
	ghost_timer.start()
	ghost_timer.timeout.connect(add_ghost)
	
func add_ghost():
	var choosen_color:Color
	ghost_color +=ida_volta
	#print_debug(ghost_color)
	match ghost_color:
		1: 
			choosen_color = Color.BLUE_VIOLET
		2: 
			choosen_color = Color.BLUE
		3: 
			choosen_color = Color.SKY_BLUE
		4: 
			choosen_color = Color.GREEN
		5: 
			choosen_color = Color.YELLOW
		6: 
			choosen_color = Color.ORANGE
		7: 
			choosen_color = Color.RED
			ida_volta = -1
	var ghost = bullet_ghost.instantiate()
	ghost.set_property(position,$BulletSprite.scale*2,choosen_color)
	#print_debug(position,$BulletSprite.scale,choosen_color)
	get_tree().current_scene.add_child(ghost)
