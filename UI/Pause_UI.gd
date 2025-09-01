extends CanvasLayer

@onready var alma_comum = %alma_comum
@onready var alma_incomum = %alma_incomum
@onready var alma_rara = %alma_rara
@onready var pause_time_count: Label = %pause_time_count
@onready var pause_kill_count: Label = %pause_kill_count
@onready var confirmation_dialog: ConfirmationDialog = %pause_confirmation

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
			pause_time_count.text = GameManager.time_elapsed_string
			pause_kill_count.text = str(GameManager.kills_count)
			show()
			get_tree().paused = true	


func _on_button_pressed() -> void:
	print_debug("testando")
	confirmation_dialog.visible = true


func _on_confirmation_dialog_confirmed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/menu.tscn")


func _on_confirmation_dialog_canceled() -> void:
	confirmation_dialog.visible = false
