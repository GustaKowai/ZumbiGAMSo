extends CharacterBody2D

var pos:Vector2
var rota:float
var dir: float
var speed:int = 600
var bullet_damage:int = 4

func _ready():
	global_position = pos
	global_rotation = rota
func _physics_process(delta):
	velocity = Vector2(speed,0).rotated(dir)
	move_and_slide()
	if GameManager.player:
		if position.distance_squared_to(GameManager.player.position) > 1000000:
			queue_free()
	else:
		queue_free()

func _on_bullet_hit_box_area_entered(area):
	if area.is_in_group("JogadorHitBox"):
		var player:Jogador  = area.get_parent()
		player.damage(bullet_damage)
		queue_free()
	if area.is_in_group("construcao"):
		queue_free()
