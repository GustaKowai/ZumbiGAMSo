extends Bullet_base
@onready var sprite:Sprite2D = $BulletSprite

var curvatura:float = 0
var cima_baixo:int


func _ready():
	set_start_position()
	bullet_damage += GameManager.upgrade_revolver[1]
	piercing += GameManager.upgrade_revolver[2]
	curvatura = 0# randf_range(-1,1)
	#print_debug(curvatura)
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
	desapear_on_distance()

func _on_bullet_hit_box_area_entered(area):
	hit_enemy(area)
	desapear_on_hit_building(area)
