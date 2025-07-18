extends CharacterBody2D

@onready var range_area:Area2D = $range
@onready var sprite:Sprite2D = $Sprite2D
@export var bullet_hit_scene:PackedScene

var pos:Vector2
var rota:float
var dir: float
var speed = 2500
var bullet_damage = 8
var nav_agent:NavigationAgent2D
var direcao_zumbi: Vector2
var area_closest_zumbi:Area2D
var position_closest_zumbi:Vector2
var menor_distancia
var entrou = false

func _ready():
	global_position = pos
	global_rotation = rota
	bullet_damage += GameManager.upgrade_metralhadora[1]

func _physics_process(delta):
	#tentando_atirar()
	if !entrou:
		velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 1000000:
			queue_free()
	else:
		queue_free()

func _on_machinegun_bullet_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		set_bullet_hit()
		#print_debug(bullet_damage)
		queue_free()
	if area.is_in_group("construcao"):
		set_bullet_hit()
		#print_debug("Acertei um predio")
		queue_free()

#func tentando_atirar():
#	var areas:Array[Area2D] = range_area.get_overlapping_areas() #Detecta todas as áreas que estão dentro da área de dano do inimigo
#	menor_distancia = 0
#	var bala_position = global_position
#	for area in areas:
#		print_debug(area)
#		if area.is_in_group("EnemyHitBox"): #Detecta se alguma área detectada é um inimigo
#			var zumbi_position = area.global_position
#			var distancia_bala_zumbi = bala_position.distance_to(zumbi_position)
#			if menor_distancia >= distancia_bala_zumbi:
#				menor_distancia = distancia_bala_zumbi
#				position_closest_zumbi = area.global_position
#				direcao_zumbi = -(position_closest_zumbi - bala_position)
#				velocity = direcao_zumbi * speed
#				print_debug("mirei")
#	velocity = Vector2(speed,0).rotated(dir)

func achando_zumbi(area:Area2D):
	#print_debug(area)
	if !entrou:
		if area.is_in_group("EnemyHitBox"):
			#print_debug("Achou zumbi")
			var enemy:Enemy
			enemy = area.get_parent()
			var zumbi_position = enemy.global_position
			var bala_position = global_position
			direcao_zumbi = -(bala_position - zumbi_position).normalized()
			velocity = direcao_zumbi * speed
			sprite.look_at(zumbi_position)
			entrou = true
	
		
func set_bullet_hit():
	if bullet_hit_scene:
		var bullet_hit = bullet_hit_scene.instantiate()
		bullet_hit.global_position = global_position
		bullet_hit.global_rotation = global_rotation
		get_parent().get_parent().add_child(bullet_hit)
