extends Node2D

var enemy: Enemy
var sprite:Sprite2D
var animation_player:AnimationPlayer
var var_diff:Vector2
var position_running:String = "side" 
var dmg_area:Area2D
var atk_direction: Vector2

@export var dano_zombie:int = 1
var attack_cooldown:float = 0.7

func _ready():
	enemy = get_parent()
	sprite =enemy.get_node("Movimento")
	dmg_area = $DmgArea
	animation_player = enemy.get_node("AnimationPlayer")

func _process(delta):
	update_atk_cd(delta)

func _physics_process(delta: float) -> void:
	if not enemy.is_attacking:
		try_attack()

func update_atk_cd(delta):
	if enemy.is_attacking:
		attack_cooldown -=delta
		if attack_cooldown <=0:
			enemy.is_attacking = false

func deal_damage_to_player():
	var areas = dmg_area.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("JogadorHitBox"):
			var player: Jogador = area.get_parent()
			var player_direction:Vector2 = (player.position - enemy.position).normalized()
			var dot_product:float = player_direction.dot(atk_direction)
			print(dot_product)
			if dot_product > 0.7:#Verifica se o Player está na frente do zumbi
				player.damage(dano_zombie)

func try_attack():
	var areas:Array[Area2D] = dmg_area.get_overlapping_areas() #Detecta todas as áreas que estão dentro da área de dano do inimigo
	for area in areas:
		if area.is_in_group("JogadorHitBox"): #Detecta se alguma área detectada é um jogador
			attack()
			
func attack():
	#Checa se já está atacando:
	if enemy.is_attacking:
		return
	#Define como atacando:
	enemy.is_attacking = true
	attack_cooldown = 0.6
	#Define a animação que será usada para atacar
	if enemy.follow.position_running == "side":
		if sprite.flip_h:
			animation_player.play("Atk_left")
			atk_direction = Vector2.LEFT
		if not sprite.flip_h:
			animation_player.play("Atk_right")
			atk_direction = Vector2.RIGHT
	elif enemy.follow.position_running == "down":
		animation_player.play("Atk down")
		atk_direction = Vector2.DOWN
	else:
		animation_player.play("Atk up")
		atk_direction = Vector2.UP
