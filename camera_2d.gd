extends Camera2D

@export var target_path: NodePath
@onready var target: Node2D = get_node(target_path)

func _process(_delta: float) -> void:
	global_position = target.global_position
