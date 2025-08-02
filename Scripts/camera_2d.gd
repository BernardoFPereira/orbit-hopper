extends Camera2D

@export var target: Node2D
var last_known_pos: Vector2

func _process(delta: float) -> void:
	
	if target:
		last_known_pos = target.global_position
		global_position = global_position.lerp(last_known_pos, delta * 2)
	else:
		global_position = global_position.lerp(last_known_pos, delta)
