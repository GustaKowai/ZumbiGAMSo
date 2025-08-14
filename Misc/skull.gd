extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_player.play()
	animation_player.play("FLip")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
