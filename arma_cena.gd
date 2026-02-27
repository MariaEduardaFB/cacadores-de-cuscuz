extends Node2D

@export var damage: int = 1

@onready var sprite: Sprite2D = $Sprite2D

# Direção que a arma está "apontando" (o Zé pode chamar isso)
func set_facing(dir: Vector2) -> void:
	# Versão simples: só espelha esquerda/direita
	if abs(dir.x) > abs(dir.y):
		sprite.flip_h = dir.x < 0

	# Se quiser girar a arma pra cima/baixo também, descomente:
	# if dir.length() > 0.0:
	#     rotation = dir.angle()
