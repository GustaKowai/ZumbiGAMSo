extends CanvasLayer


func _ready():
	hide()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if visible:
			hide()
			get_tree().paused = false
		else:
			show()
			get_tree().paused = true	
