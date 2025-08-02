extends StaticBody2D

@onready var orbit: Node2D = $Orbit
@onready var orbit_area: Area2D = $OrbitArea

var textures := [Texture2D]
var player: CharacterBody2D
var orbit_speed := 2.0

func _ready() -> void:
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
					# TODO: DIE!!!!!
					orbit_speed = abs(orbit_speed)
					body.orbit_clockwise = true
					print("Planet in front of ship!")
				
			body.orbit_target = self
			body.speed = 200
			body.call_deferred("reparent", orbit)
			body.set_state(body.States.Orbit)
