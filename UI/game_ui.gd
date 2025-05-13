extends CanvasLayer
@onready var timer_label = %timer_label
@onready var kills_label = %kills_label
@onready var ammo_label = %ammo_label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManager.is_game_over: return
	
	timer_label.text = GameManager.time_elapsed_string
	kills_label.text = str(GameManager.kills_count)
	ammo_label.text = str(GameManager.ammo)
