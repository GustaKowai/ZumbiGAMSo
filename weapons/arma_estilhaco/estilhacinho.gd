extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed:int = 800
var piercing = 0
var bullet_damage
var tempo_sem_dar_dano = 0.05
@export var bullet_hit_scene:PackedScene

func _ready():
	global_position = pos
	global_rotation = rota
	
func _physics_process(delta):
	velocity = Vector2.RIGHT.rotated(rotation) * speed
	move_and_slide()
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 1000000:
			queue_free()
	else:
		queue_free()

func _process(delta: float) -> void:
	tempo_sem_dar_dano -= delta

func _on_bullet_hit_box_area_entered(area):
	if tempo_sem_dar_dano > 0:
		return
	
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		set_bullet_hit()
		if piercing <= 0:
			queue_free()
		piercing -= 1
	if area.is_in_group("construcao"):
		set_bullet_hit()
		#print("Acertei um predio")
		queue_free()
		
func set_bullet_hit():
	if bullet_hit_scene:
		var bullet_hit = bullet_hit_scene.instantiate()
		bullet_hit.global_position = global_position
		bullet_hit.global_rotation = global_rotation
		get_parent().get_parent().add_child(bullet_hit)
