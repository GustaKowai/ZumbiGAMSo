extends Node2D

@onready var enemy:Enemy
@onready var animation_player:AnimationPlayer
@onready var timer_node: Timer = $Timer
@export var speed:float
@export var run_timer:float
@export var range_desvio:float = PI/5
@export var stun_time:float = 5.0
var is_run_on_cd:bool
var timer:float = 0

func _ready() -> void:
	enemy = get_parent()
	animation_player = enemy.animation_player
	
func _physics_process(delta: float) -> void:
	update_run_timer(delta)
	enemy.move_and_slide()
	
func update_run_timer(delta):
	if is_run_on_cd:
		if timer <= run_timer:
			timer += delta
		else:
			corre_pro_player()
			is_run_on_cd = false
			timer = 0

func mira_no_player():
	if GameManager.player:
		var player:Jogador = GameManager.player
		var player_position:Vector2 = player.global_position
		var posicao_mira:Vector2 = player_position-enemy.global_position
		return posicao_mira
		
func corre_pro_player():
	animation_player.play("ataque")
	enemy.velocity = mira_no_player().normalized()*speed
	timer_node.start(stun_time)

func _on_hit_box_area_body_entered(body: Node2D) -> void:
	var desvio:float = randf_range(-range_desvio,range_desvio)
	enemy.velocity = enemy.velocity.rotated(PI+desvio)

func _on_timer_timeout() -> void:
	animation_player.play("idle")
	enemy.velocity = Vector2(0,0)
	is_run_on_cd = true
