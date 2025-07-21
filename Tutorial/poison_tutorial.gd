extends TileMapLayer
@onready var damage_area: Area2D = $DamageArea
@export var dano:int = 1
var timer:float = 0

func _process(delta: float) -> void:
	timer += delta
	if timer >= 1:
		timer = 0
		var areas_afetadas:Array[Area2D] = damage_area.get_overlapping_areas()
		#Verificacao das areas afetadas
		for areas in areas_afetadas:
			#Se a area for do Jogador, ele recebe o dano de player
			if areas.is_in_group("JogadorHitBox"):
				var jogador:Jogador = areas.get_parent()
				if jogador.position.x > 0:
					jogador.position.x -= 54
				elif jogador.position.x < 0:
					jogador.position.x += 54
