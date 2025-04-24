class_name Enemy
extends CharacterBody2D

@onready var dmg_area = $DmgArea
@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var follow = $FollowPlayer
@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D

@export_category("Fight")
@export var enemy_health = 40
@export var death_prefab:PackedScene
@export var dano_zombie = 1
@export var speed = 20
@export var player: Node2D

var atk_direction: Vector2
var is_attacking = false
var attack_cooldown = 0.6
var died = false


func _process(delta):
	update_atk_cd(delta)

func damage(amount: int):
	enemy_health -=amount
	print("Inimigo recebeu dano de ",amount,"A vida total é de ",enemy_health)
	#piscar o inimigo:
	modulate = Color.ORANGE
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
	if enemy_health <=0 and not died:
		died = true
		print("Morri")
		die()

func deal_damage_to_player():
	var areas = dmg_area.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("JogadorHitBox"):
			var player: Jogador = area.get_parent()
			var player_direction = (player.position - position).normalized()
			var dot_product = player_direction.dot(atk_direction)
			print(dot_product)
			if dot_product > 0.3:
				player.damage(dano_zombie)

func attack():
	#Checa se já está atacando:
	if is_attacking:
		return
	#Define como atacando:
	print("Ataquei")
	is_attacking = true
	attack_cooldown = 0.6
	if follow.position_running == "side":
		animation_player.play("Atk")
		if sprite.flip_h:
			atk_direction = Vector2.LEFT
		if not sprite.flip_h:
			atk_direction = Vector2.RIGHT
	elif follow.position_running == "down":
		animation_player.play("Atk down")
		atk_direction = Vector2.DOWN
	else:
		animation_player.play("Atk up")
		atk_direction = Vector2.UP

func update_atk_cd(delta):
	if is_attacking:
		attack_cooldown -=delta
		if attack_cooldown <=0:
			is_attacking = false

func die():
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	
	queue_free()

