extends Node2D

@export var growth_rate := Vector2(0.3, 0.3)

@onready var inner_effect: GPUParticles2D = $GPUParticles2D2

func _process(delta: float) -> void:
	scale += growth_rate * delta
	
	if scale >= Vector2(1.5, 1.5):
		switch_inner_fx()

func switch_inner_fx() -> void:
	if !inner_effect.visible:
		inner_effect.visible = true
