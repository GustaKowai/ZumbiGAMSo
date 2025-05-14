extends CanvasLayer
@onready var timer_label = %timer_label
@onready var kills_label = %kills_label
@onready var ammo_label = %ammo_label
@onready var infection_bar = $infection_bar
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.is_game_over: return
	
	infection_bar.value = GameManager.infection_level
	if infection_bar.value >= 100:
		GameManager.end_game()
	timer_label.text = GameManager.time_elapsed_string
	kills_label.text = str(GameManager.kills_count)
	ammo_label.text = str(GameManager.ammo)
