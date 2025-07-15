extends CharacterBody2D
var pos:Vector2
var rota:float
var dir: float
var speed:int = 600
var bullet_damage:int = 10
var multipicador_vel:float = 0.5 #Essa variavel vai multiplicar a velocidade do zumbi para diminui-la
var piercing = 0
@export var slow_effect:PackedScene

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
	if area.is_in_group("EnemyHitBox"):
		var enemy:Enemy  = area.get_parent()
		enemy.damage(bullet_damage)
		if not enemy.is_in_group("tanque"):
			enemy.modulate = Color.GOLDENROD
			var slow = slow_effect.instantiate()
			enemy.add_child(slow)
			var zombie_movement = enemy.get_node("FollowPlayer")
			zombie_movement.speed *= multipicador_vel
		if piercing <= 0:
			queue_free()
		piercing -= 1
	if area.is_in_group("construcao"):
		#print("Acertei um predio")
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
