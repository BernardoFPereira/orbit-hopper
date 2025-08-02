extends StaticBody2D

@onready var orbit: Node2D = $Orbit
@onready var orbit_area: Area2D = $OrbitArea
@onready var mesh_instance: MeshInstance2D = $MeshInstance

const BLUE = preload("res://Assets/Planets/Blue.png")
const GREEN = preload("res://Assets/Planets/Green.png")
const SATELLITE = preload("res://Assets/Planets/Satellite.png")
const GAS = preload("res://Assets/Planets/Gas.png")
const GAS_2 = preload("res://Assets/Planets/Gas2.png")
const DATHO = preload("res://Assets/Planets/Datho.png")
const KASHYI = preload("res://Assets/Planets/Kashyi.png")
const NEFO = preload("res://Assets/Planets/Nefo.png")

const HALO = preload("res://Assets/Planets/Halo.png")
const CUBE = preload("res://Assets/Planets/Cube.png")
const SOMEWHERE = preload("res://Assets/Ships/Somewhere.png")

const SOL = preload("res://Assets/Planets/Sol.png")
const BLACK_HOLE = preload("res://Assets/Planets/BlackHole.png")

@export var textures := [
	BLUE,
	GREEN,
	SATELLITE,
	GAS,
	GAS_2,
	DATHO,
	KASHYI,
	NEFO,
	SOL,
	]

@export var textures_special := [
	CUBE,
	HALO,
	SOMEWHERE,
]

var player: CharacterBody2D
var orbit_speed := 2.0
var special := false

func _ready() -> void:
	var rand_idx: int
	
	if special:
		rand_idx = randi_range(0, len(textures_special) - 1)
		mesh_instance.texture = textures_special[rand_idx]
	else:
		rand_idx = randi_range(0, len(textures) - 2)
		mesh_instance.texture = textures[rand_idx]
		
	if scale.x > 2.4:
		mesh_instance.texture = SOL
	
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	orbit.rotate(orbit_speed * delta)

func _on_orbit_area_body_entered(body: Node2D) -> void: 
	if body.is_in_group("Player"):
		if body.state == body.States.Flying:
			match body.check_orbit_side(global_position):
				body.ContactDir.RIGHT:
					#print("Planet to the right of ship!")
					orbit_speed = abs(orbit_speed)
					body.orbit_clockwise = true
					
				body.ContactDir.LEFT:
					#print("Planet to the left of ship!")
					orbit_speed = orbit_speed * -1
					body.orbit_clockwise = false
					
				body.ContactDir.FRONT:
					#print("Planet in front of ship!")
					body.set_collision_layer_value(2, 0)
					orbit_speed = abs(orbit_speed)
					body.orbit_clockwise = true
					body.set_state(body.States.Dead)
					return
				
			body.orbit_target = self
			body.speed = 200
			body.call_deferred("reparent", orbit)
			body.set_state(body.States.Orbit)
