extends TextureProgressBar
@onready var timer = $Timer
@onready var damage_bar = $DamageBar

func _ready() -> void:
	GameManager.player_damaged.connect(update_health_bar)
	max_value = GameManager.player.max_health
	damage_bar.max_value = max_value
	value = GameManager.player.player_health
	damage_bar.value = value

func _process(delta: float) -> void:
	#update_health_bar()
	if damage_bar.value > value:
		damage_bar.value -= delta*2.0
	
func update_health_bar():
	if GameManager.player:
		max_value = GameManager.player.max_health
		print(max_value)
		damage_bar.max_value = max_value
		value = GameManager.player.player_health
		#timer.start()
func _on_timer_timeout() -> void:
	damage_bar.value = GameManager.player.player_health
