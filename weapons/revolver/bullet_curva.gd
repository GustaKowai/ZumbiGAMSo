extends CharacterBody2D
@onready var sprite:Sprite2D = $BulletSprite

var pos:Vector2
var rota:float
var dir: float
var speed:int = 200
var bullet_damage:int = 30
var piercing = 3
var curvatura:float = 0
var cima_baixo:int

func _ready():
	global_position = pos
	global_rotation = rota
	bullet_damage += GameManager.upgrade_revolver[1]
	piercing += GameManager.upgrade_revolver[2]
	curvatura = 0# randf_range(-1,1)
	print(curvatura)
	if GameManager.ammo % 2 == 0:
		cima_baixo = -1
		sprite.modulate = Color.BLUE
	else:
		cima_baixo = 1
		sprite.modulate = Color.RED
func _physics_process(delta):
	dir = cima_baixo*sin(curvatura) 
	curvatura += 0.5
	global_rotation = rota+dir
	velocity = Vector2(speed,0).rotated(rota+dir)
	move_and_slide()
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 1000000:
			queue_free()
	else:
		queue_free()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		if piercing <= 0:
			queue_free()
		piercing -= 1
	if area.is_in_group("construcao"):
		#print("Acertei um predio")
		queue_free()
