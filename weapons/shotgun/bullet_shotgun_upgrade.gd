extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed = 1750
@export var bullet_damage = 10
@export var bullet_duracao = 0.48
@export var bullet_ghost:PackedScene
var bullet_tempodevida = 0
var inversao_direcao = 1
var ghost_color = 0
var ghost_timer = Timer.new()
var ida_volta = 1

func _ready():
	global_position = pos
	global_rotation = rota
	bullet_damage += GameManager.upgrade_shotgun[1]
	bullet_duracao*= GameManager.upgrade_shotgun[3]*1.0/100
	set_ghosts()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self,"speed",-speed, bullet_duracao)
	#var color_tween = create_tween()
	#color_tween.set_trans(Tween.TRANS_LINEAR)
	#color_tween.tween_property(self,"modulate",Color.BLUE_VIOLET,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.BLUE,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.SKY_BLUE,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.GREEN,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.YELLOW,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.ORANGE,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.RED,bullet_duracao/14)
	#
	#color_tween.tween_property(self,"modulate",Color.RED,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.ORANGE,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.YELLOW,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.GREEN,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.SKY_BLUE,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.BLUE,bullet_duracao/14)
	#color_tween.tween_property(self,"modulate",Color.BLUE_VIOLET,bullet_duracao/14)
#Tentativa de fazer as balas desaparecerem depois de um tempo
func _process(delta):
	bullet_tempodevida += delta
	#if bullet_duracao < bullet_tempodevida:
	#	inversao_direcao = -1
	if bullet_tempodevida > bullet_duracao:
		queue_free()
	
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	#print_debug(speed)
	move_and_slide()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		#enemy.follow.knockback(velocity,0.2)
		#queue_free()
	if area.is_in_group("construcao"):
		#print("Acertei um predio")
		queue_free()

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
	
