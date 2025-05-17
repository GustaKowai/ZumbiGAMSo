extends CanvasLayer
@onready var timer_label = %timer_label
@onready var kills_label = %kills_label
@onready var ammo_label = %ammo_label
@onready var infection_bar = $infection_bar
@onready var weapon_bar = $EspacoArma/Weapon_bar
@onready var item_sprite = $Consumivel/item_sprite
@onready var stamina_bar = $player_life_and_stamina/StaminaBar
@onready var health_bar = $player_life_and_stamina/HealthBar
var texture_weapon:Texture2D = null
var texture_item:Texture2D = null
# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_bar.texture_under = null
	weapon_bar.texture_over = null
	GameManager.weapon_collected.connect(change_weapon_equiped)
	GameManager.item_collected.connect(change_item_equiped)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.is_game_over: return
	update_infection_bar()
	update_stamina_bar()
	update_health_bar()
	timer_label.text = GameManager.time_elapsed_string
	kills_label.text = str(GameManager.kills_count)
	ammo_label.text = str(GameManager.ammo)
	if GameManager.player.weapon_cooldown and GameManager.weapon_cd:
		if GameManager.player.weapon_cooldown >=0:
			weapon_bar.value = (GameManager.player.weapon_cooldown/GameManager.weapon_cd)*100
			#print(weapon_bar.value)
	if GameManager.ammo == 0 and texture_weapon:
		texture_weapon = null
		weapon_bar.texture_under = null
		weapon_bar.texture_over = null

func change_weapon_equiped(weapon_sprite_path):
	texture_weapon = load(weapon_sprite_path)
	weapon_bar.texture_under = texture_weapon
	weapon_bar.texture_progress = texture_weapon
	print(weapon_sprite_path)
	print("troquei")

func change_item_equiped(item_sprite_path):
	if item_sprite_path:
		texture_item = load(item_sprite_path)
		item_sprite.texture = texture_item
		print(item_sprite_path)
	else:item_sprite.texture = null
		
func update_infection_bar():
	infection_bar.value = GameManager.infection_level
	if infection_bar.value >= 100:
		GameManager.texto_morte = "Você deixou acumular muitos zumbis"
		GameManager.player.die()

func update_health_bar():
	if GameManager.player:
		health_bar.max_value = GameManager.player.max_health
		health_bar.value = GameManager.player.player_health

func update_stamina_bar():
	if GameManager.player:
		stamina_bar.max_value = GameManager.player.max_stamina
		stamina_bar.value = GameManager.player.stamina_value
		if stamina_bar.value <GameManager.player.dash_cost:
			stamina_bar.tint_progress = Color(0.5,0.5,0.5,1)
		else:
			stamina_bar.tint_progress = Color(1,1,1,1)
