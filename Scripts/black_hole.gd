extends Node2D

@export var growth_rate := Vector2(0.3, 0.3)

@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var camera: Camera2D = $"../Camera2D"
@onready var inner_effect: GPUParticles2D = $GPUParticles2D2

func _ready() -> void:
	var off_x = randf_range(-200, 200)
	var off_y = randf_range(-200, 200)
	
	global_position = camera.global_position + Vector2(off_x, off_y)

func _process(delta: float) -> void:
	scale += growth_rate * delta
	
	if scale >= Vector2(1.5, 1.5):
		switch_inner_fx()

func switch_inner_fx() -> void:
	if !inner_effect.visible:
		inner_effect.visible = true
