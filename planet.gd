extends StaticBody2D

@onready var orbit: Node2D = $Orbit
@onready var orbit_area: Area2D = $OrbitArea

var player: CharacterBody2D
#var player_in_orbit := false
var orbit_speed := 2.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _process(delta: float) -> void:
	orbit.rotate(orbit_speed * delta)

func _on_orbit_area_body_entered(body: Node2D) -> void: 
	print("----- OOPS -----")
	if body.is_in_group("Player"):
		#player_in_orbit = true
		body.orbit_target = self
		body.speed = 200
		body.call_deferred("reparent", orbit)
		body.set_state(body.States.Orbit)
