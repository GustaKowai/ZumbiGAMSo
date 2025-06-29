extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed = 1750
@export var bullet_damage = 10
var bullet_duracao = 0.17
var bullet_tempodevida = 0
var inversao_direcao = 1

func _ready():
	global_position = pos
	global_rotation = rota
	bullet_damage += GameManager.upgrade_shotgun[1]
	bullet_duracao*= GameManager.upgrade_shotgun[3]*1.0/100
	
#Tentativa de fazer as balas desaparecerem depois de um tempo
func _process(delta):
	bullet_tempodevida += delta
	if bullet_duracao < bullet_tempodevida:
		inversao_direcao = -1
	if (2 * bullet_duracao) < bullet_tempodevida:
		queue_free()
		
		
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir) * inversao_direcao
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

	
