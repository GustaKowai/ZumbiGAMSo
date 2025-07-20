extends CharacterBody2D

@onready var area_de_dano:Area2D = $DamageArea
var pos:Vector2
var rota:float
var dir: float
@export var speed:int = 800
@export var bullet_damage:int = 8
@export var explosao:PackedScene
var raio_explosao:float = 144.0
var ID:int

func _ready():
	global_position = pos
	global_rotation = rota
	var colisao:CollisionShape2D = area_de_dano.get_child(0)
	colisao.shape.radius = raio_explosao
	
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 1000000:
			queue_free()
	else:
		queue_free()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("JogadorHitBox") or area.is_in_group("construcao")or area.is_in_group("alvo"):
		if area.is_in_group("alvo"):
			var alvo = area.get_parent()
			area_de_dano = alvo.area_damage
			#print_debug(area)
		var area_da_explosao = area_de_dano.get_overlapping_areas()
		#print_debug(area_da_explosao)
		for areas_afetadas in area_da_explosao:
			if areas_afetadas.is_in_group("JogadorHitBox"):
				var player:Jogador = areas_afetadas.get_parent()
				player.damage(bullet_damage)
		if explosao:
			var explosion = explosao.instantiate()
			explosion.position = position
			if area.is_in_group("alvo"):
				explosion.global_position = area.global_position
			var colisao:CollisionShape2D = area_de_dano.get_child(0)
			var modificador_escala = raio_explosao/144.0
			explosion.scale = Vector2(modificador_escala,modificador_escala)
			explosion.get_node("Explosao").scale = (Vector2(1/modificador_escala,1/modificador_escala))
			get_parent().add_child(explosion)
		GameManager.bala_explodida.emit(ID)
		queue_free()
		#speed = 0
