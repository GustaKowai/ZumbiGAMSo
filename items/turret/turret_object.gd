extends StaticBody2D

@onready var turret_head:Sprite2D = $turretHead
@onready var range_area:Area2D = $Range
@onready var marker:Marker2D = %bullet_point
@export var turret_duration:float
@export var bullet_scene:PackedScene
var enemy_position:Vector2
var shooting_cooldown = 0.2
var shooting:bool

func _ready() -> void:
	shooting = false
	
func _process(delta: float) -> void:
	turret_duration -=delta
	shooting_cooldown -= delta
	if shooting_cooldown <= 0:
		shooting = false
		shooting_cooldown = 0.2
	try_shoot()
	if turret_duration <=0:
		despawn()

func fire_bullet(target):
	var local_target = target-global_position
	turret_head.flip_v = local_target.x < 0
	print(local_target.x)
	print(turret_head.flip_v)
	turret_head.look_at(target)
	shooting = true
	#Determina a direção do tiro e cria a bala
	var bullet = bullet_scene.instantiate()
	bullet.dir = Vector2.RIGHT.angle_to(local_target)
	print(bullet.dir)
	bullet.pos = marker.global_position
	bullet.rota = Vector2.RIGHT.angle_to(local_target)
	get_parent().add_child(bullet)#Instancia a bala
	
func despawn():
	queue_free()

func try_shoot():
	if shooting:return
	var areas:Array[Area2D] = range_area.get_overlapping_areas() #Detecta todas as áreas que estão dentro da área de dano do inimigo
	for area in areas:
		if area.is_in_group("EnemyHitBox"): #Detecta se alguma área detectada é um inimigo
			if shooting:return
			fire_bullet(area.global_position)
