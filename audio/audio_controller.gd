extends Node2D
@onready var shoot_sound: AudioStreamPlayer = $ShootSound
@onready var keep_shooting_machine_gun: AudioStreamPlayer = $keepShootingMachineGun

@export var biblioteca_armas:Dictionary[String,Resource]
@export var biblioteca_armas_upadas:Dictionary[String,Resource]
@export var biblioteca_em_uso:Dictionary[String,Resource]
@export var checagem_de_upgrades:Dictionary[String,int]
func _ready() -> void:
	GameManager.weapon_collected.connect(change_weapon_sound)
	
func play_shoot():
	shoot_sound.play()

func keep_shooting():
	keep_shooting_machine_gun.play()

func stop_shooting():
	keep_shooting_machine_gun.stop()
	
func change_weapon_sound(weapon):
	check_upgrades()
	#print_debug(weapon)
	if checagem_de_upgrades.has(weapon):
		if checagem_de_upgrades[weapon] == 1:
			biblioteca_em_uso = biblioteca_armas_upadas
		else:
			biblioteca_em_uso = biblioteca_armas
	#print_debug(biblioteca_armas[weapon])
	if biblioteca_em_uso.has(weapon):
		shoot_sound.stream = biblioteca_em_uso[weapon]
	else:
		shoot_sound.stream = null
func check_upgrades():
	checagem_de_upgrades["res://weapons/revolver/revolver_icon_2.png"] = GameManager.upgrade_revolver[3]
	#checagem_de_upgrades["res://weapons/magnum/magnum_icon.png"] = GameManager.upgrade_revolver[4]
	checagem_de_upgrades["res://weapons/shotgun/shotgun_icon.png"] = GameManager.upgrade_shotgun[5]
	#print_debug(checagem_de_upgrades)
	#print_debug(GameManager.upgrade_revolver)
	
