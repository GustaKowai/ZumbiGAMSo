extends CanvasLayer
@onready var timer_label:Label = %timer_label
@onready var kills_label:Label = %kills_label
@onready var ammo_label:Label = %ammo_label
@onready var infection_bar:TextureProgressBar = $infection_bar
@onready var weapon_bar:TextureProgressBar = $EspacoArma/Weapon_bar
@onready var item_sprite:TextureRect = $Consumivel/item_sprite
@onready var stamina_bar:TextureProgressBar = $player_life_and_stamina/StaminaBar
@onready var health_bar:TextureProgressBar = $player_life_and_stamina/HealthBar
@onready var damage_bar:TextureProgressBar = $player_life_and_stamina/DamageBar
@onready var heart:AnimatedSprite2D = $player_life_and_stamina/Beating_heart
@onready var vinheta:Sprite2D = $Vinheta
@onready var coin_label:Label = %coin_label
@onready var almaComum:Sprite2D = $Ui_top/AlmaZumbiComum
@onready var almaIncomum:Sprite2D = $Ui_top/AlmaZumbiIncomum
@onready var almaRara:Sprite2D = $Ui_top/AlmaZumbiRaro
var texture_weapon:Texture2D = null
var texture_item:Texture2D = null
# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_bar.texture_under = null
	weapon_bar.texture_over = null
	item_sprite.texture = null
	vinheta.modulate.a = 0
	update_souls_UI()
	GameManager.weapon_collected.connect(change_weapon_equiped)
	GameManager.item_collected.connect(change_item_equiped)
	GameManager.coin_collected.connect(update_coin_count)
	GameManager.life_changed.connect(update_damaged_UI)
	GameManager.zombie_died.connect(update_souls_UI)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.is_game_over: return
	update_infection_bar()
	update_stamina_bar()
	update_weapon_cd()
	timer_label.text = GameManager.time_elapsed_string
	kills_label.text = str(GameManager.kills_count)
	ammo_label.text = str(GameManager.ammo)
	

func change_weapon_equiped(weapon_sprite_path):
	texture_weapon = load(weapon_sprite_path)
	weapon_bar.texture_under = texture_weapon
	weapon_bar.texture_progress = texture_weapon
	print("troquei")

func change_item_equiped(item_sprite_path):
	if item_sprite_path:
		texture_item = load(item_sprite_path)
		item_sprite.texture = texture_item
	else:item_sprite.texture = null
		
func update_infection_bar():
	infection_bar.value = GameManager.infection_level
	if infection_bar.value >= 100:
		GameManager.texto_morte = "Você deixou acumular muitos zumbis"
		GameManager.player.die()
		
func update_stamina_bar():
	if GameManager.player:
		stamina_bar.max_value = GameManager.player.max_stamina
		stamina_bar.value = GameManager.player.stamina_value
		if stamina_bar.value <GameManager.player.dash_cost:
			stamina_bar.tint_progress = Color(0.5,0.5,0.5,1)
		else:
			stamina_bar.tint_progress = Color(1,1,1,1)
			
func update_coin_count():
	coin_label.text = str(GameManager.coin_count)

func update_weapon_cd():
	if GameManager.player.weapon_cooldown and GameManager.weapon_cd:
		if GameManager.player.weapon_cooldown >=0:
			var player_cd:float = round_to_dec(GameManager.player.weapon_cooldown,2) 
			weapon_bar.value = (player_cd-0.01/GameManager.weapon_cd)*100
			#print("weapon cd atual =", player_cd)
			#print("weapon cd=", GameManager.weapon_cd)
			#print(weapon_bar.value)
	if GameManager.ammo == 0 and texture_weapon:
		texture_weapon = null
		weapon_bar.texture_under = null
		weapon_bar.texture_over = null
		
#Mudanças da UI de acordo com o HP do jogador:		
func update_damaged_UI():
	var player_proporcional_health:float = GameManager.player.player_health*1.0/GameManager.player.max_health*1.0
	if player_proporcional_health > 0.5:
		vinheta.modulate.a = 0
	else:
		vinheta.modulate.a = 1.5-player_proporcional_health*3
	if player_proporcional_health> 0.7:
		heart.speed_scale = 1.0
	elif player_proporcional_health < 0.7 and player_proporcional_health >0.3:
		heart.speed_scale = 2.0
	elif player_proporcional_health < 0.3:
		heart.speed_scale = 3.0
	
func update_souls_UI():
	almaComum.visible = GameManager.alma_comum > 0
	almaIncomum.visible = GameManager.alma_incomum > 0
	almaRara.visible = GameManager.alma_rara > 0

func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
