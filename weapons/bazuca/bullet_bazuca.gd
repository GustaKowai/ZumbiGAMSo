extends CharacterBody2D

@onready var area_de_dano =  $area_dano
@export var explosao:PackedScene

var pos:Vector2
var rota:float
var dir: float
var speed = 500
var bullet_damage = 50

func _ready():
	global_position = pos
	global_rotation = rota
	bullet_damage += GameManager.upgrade_bazuca[1]

func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 1000000:
			queue_free()
	else:
		queue_free()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
		var area_da_explosao = area_de_dano.get_overlapping_areas()
		for areas_afetadas in area_da_explosao:
			if areas_afetadas.is_in_group("EnemyHitBox"):
				var enemy:Enemy = areas_afetadas.get_parent()
				enemy.damage(bullet_damage)
				if explosao:
					var explosion = explosao.instantiate()
					explosion.position = position
					var colisao:CollisionShape2D = area_de_dano.get_child(0)
					var raio_explosao = colisao.shape.radius
					print(raio_explosao)
					var modificador_escala = raio_explosao/96.0
					explosion.scale = Vector2(modificador_escala,modificador_escala)
					get_parent().add_child(explosion)
				queue_free()
	if area.is_in_group("construcao"):
		#print("Acertei um predio")
		queue_free()
