extends Node2D
@onready var sprite:AnimatedSprite2D = $Sprite
@onready var timer:Timer = $Sprite/Timer
@onready var item_sprite:TextureRect = $Sprite2D/TextureRect
@onready var value:Label = %value
@onready var aviso:Label = %aviso
@onready var marker:Marker2D = $Marker2D
@export var lista_itens:Array[PackedScene]
@export var lista_precos:Array[int]
@export var item:PackedScene
var esgotado:bool = false
var texture_item:Texture2D = null
var escolha:int

func _ready() -> void:
	start_shop()
	sprite.play("idle")
	aviso.visible = false
	set_timer()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("buy"):
		if aviso.visible and not esgotado:
			check_money()
			print("tentei comprar")


#region animation
func _on_timer_timeout() -> void:
	if esgotado: queue_free()
	var change = randi_range(1,6)
	match change:
		1:
			sprite.play("blink")
		2:
			sprite.play("look_around")
		_:
			sprite.play("idle")
	set_timer()
	
func set_timer():
	timer.wait_time = randf_range(1,4)
	timer.start()
#endregion
	
func start_shop():
	escolha = randi_range(0,lista_itens.size()-1)
	print(escolha)
	var item_escolhido:PackedScene = lista_itens[escolha]
	var item = item_escolhido.instantiate()
	print(item.image)
	texture_item = load(item.image)
	item_sprite.texture = texture_item
	value.text = "$ "+str(lista_precos[escolha])
	
	
func check_money():
	if lista_precos[escolha] > GameManager.coin_count:
		aviso.text = "Você não tem dinheiro suficiente!"
	else:
		aviso.text = "Aproveite"
		GameManager.coin_count -= lista_precos[escolha]
		GameManager.coin_collected.emit()
		buy()
		
func buy():
	var item_escolhido:PackedScene = lista_itens[escolha]
	var item = item_escolhido.instantiate()
	item.global_position = marker.global_position
	get_parent().add_child(item)
	esgotado = true
	item_sprite.visible = false
	sprite.play("bye")
	timer.wait_time = 1
	timer.start()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	aviso.text = "Aperte Q para comprar"
	aviso.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	aviso.visible = false
