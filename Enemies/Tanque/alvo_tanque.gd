extends Sprite2D
var ID:int
@onready var area_damage:Area2D = $Damage_area
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	GameManager.bala_explodida.connect(sumir)
	audio_player.play()
	await get_tree().create_timer(3.0,false).timeout
	queue_free()
	
func sumir(ID_recebido):
	if ID == ID_recebido:
		queue_free()
	else:
		return
