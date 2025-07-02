extends Node2D

@onready var enemy:Enemy
@onready var hitbox:Area2D
@export var damage:int
@export var damage_timer:float
@export var controle_de_buff_de_dano:float = 1
var is_damage_on_cd:bool
var timer:float = 0
func _ready() -> void:
	enemy = get_parent()
	damage += snappedi(controle_de_buff_de_dano*enemy.buff,1)
	#print_debug("Dano do piao = ",damage)
	
func _process(delta: float) -> void:
	update_damage_timer(delta)

func _on_hit_box_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("JogadorHitBox") and not is_damage_on_cd:
		var player:Jogador  = area.get_parent()
		player.damage(damage)
		is_damage_on_cd = true
		#print_debug("Tomou dano do pião")
		
func update_damage_timer(delta):
	if is_damage_on_cd:
		if timer <= damage_timer:
			timer += delta
		else:
			is_damage_on_cd = false
			timer = 0
