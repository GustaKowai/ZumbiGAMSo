extends Control

var progress = []
var sceneName:String
var scene_load_status:int = 0
@onready var tip_text: Label = %tipText
@onready var progress_bar: ProgressBar = $CenterContainer/ProgressBar
@export var tips:Array[String]

func _ready() -> void:
	sceneName = GameManager.scene_to_load
	ResourceLoader.load_threaded_request(sceneName)
	tip_text.text = tips[randi_range(0,tips.size()-1)]
	
func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName,progress)
	progress_bar.value = floor(progress[0]*100)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var new_scene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(new_scene)
