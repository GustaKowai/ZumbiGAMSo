extends CanvasLayer

@onready var alma_comum = %alma_comum
@onready var alma_incomum = %alma_incomum
@onready var alma_rara = %alma_rara

func _ready():
	hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			alma_comum.text = str(GameManager.alma_comum)
			alma_incomum.text = str(GameManager.alma_incomum)
			alma_rara.text = str(GameManager.alma_rara)
			show()
			get_tree().paused = true	
