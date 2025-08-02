extends StaticBody2D

@onready var orbit: Node2D = $Orbit
@onready var orbit_area: Area2D = $OrbitArea
@onready var mesh_instance: MeshInstance2D = $MeshInstance

const BLUE = preload("res://Assets/Planets/Blue.png")
const CUBE = preload("res://Assets/Planets/Cube.png")
const GAS_2 = preload("res://Assets/Planets/Gas2.png")
const GAS = preload("res://Assets/Planets/Gas.png")
const GREEN = preload("res://Assets/Planets/Green.png")
const HALO = preload("res://Assets/Planets/Halo.png")
const SATELLITE = preload("res://Assets/Planets/Satellite.png")

@export var textures := [
	BLUE,
	CUBE,
	GAS_2,
	GAS,
	GREEN,
	HALO,
	SATELLITE,
	]
	
var player: CharacterBody2D
var orbit_speed := 2.0

func _ready() -> void:
	var rand_idx = randi_range(0, len(textures) - 1)
	mesh_instance.texture = textures[rand_idx]
	
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	orbit.rotate(orbit_speed * delta)

func _on_orbit_area_body_entered(body: Node2D) -> void: 
	if body.is_in_group("Player"):
		if body.state == body.States.Flying:
			match body.check_orbit_side(global_position):
				body.ContactDir.RIGHT:
					orbit_speed = abs(orbit_speed)
					body.orbit_clockwise = true
					print("Planet to the right of ship!")
					
				body.ContactDir.LEFT:
					orbit_speed = orbit_speed * -1
					body.orbit_clockwise = false
					print("Planet to the left of ship!")
					
				body.ContactDir.FRONT:
					body.set_collision_layer_value(2, 0)
					orbit_speed = abs(orbit_speed)
					body.orbit_clockwise = true
					print("Planet in front of ship!")
					body.set_state(body.States.Dead)
					return
				
			body.orbit_target = self
			body.speed = 200
			body.call_deferred("reparent", orbit)
			body.set_state(body.States.Orbit)
