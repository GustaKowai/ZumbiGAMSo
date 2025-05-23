extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed = 2000
@export var bullet_damage = 40
var bullet_duracao = 0.12
var bullet_tempodevida = 0

func _ready():
	global_position = pos
	global_rotation = rota
	
#Tentativa de fazer as balas desaparecerem depois de um tempo
func _process(delta):
	bullet_tempodevida += delta
	if bullet_duracao < bullet_tempodevida:
		queue_free()
		
		
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		enemy.position +=velocity.normalized()*50
		queue_free()
	if area.is_in_group("construcao"):
		#print("Acertei um predio")
		queue_free()

	
