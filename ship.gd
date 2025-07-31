extends CharacterBody2D
class_name Player

@export var orbit_target: Node2D
@export var speed := 200

@onready var timer: Timer = $Timer

enum States {
	Orbit,
	Flying,
	Dead,
}
func set_state(new_state) -> void:
	state = new_state

var state: States = States.Flying
var last_orbit: Node2D

func _process(delta: float) -> void:
	match state:
		States.Orbit:
			velocity = Vector2.ZERO
			look_at(orbit_target.global_position)
			
		States.Flying:
			velocity = global_transform.basis_xform(Vector2.UP) * speed
			if last_orbit:
				if global_position.distance_to(last_orbit.global_position) > 100:
					print(global_position.distance_to(last_orbit.global_position))
					set_collision_layer_value(2, 1)
					last_orbit = null
			
		States.Dead:
			pass
		
	handle_input(delta)
	move_and_slide()

#func _draw() -> void:
	#draw_line(Vector2.ZERO, position + Vector2.LEFT, Color.RED, 2.0)

func handle_input(delta):
	match state:
		States.Orbit:
			if Input.is_action_pressed("launch"):
				print("charging")
				print(orbit_target.orbit_speed)
				orbit_target.orbit_speed += 0.1
				set_collision_layer_value(2, 0)
				
			if Input.is_action_just_released("launch"):
				print("GO!!!!!")
				reparent(get_tree().root.get_node("Node"))
				
				speed *= orbit_target.orbit_speed / 2
				orbit_target.orbit_speed = 2.0
				last_orbit = orbit_target
				orbit_target = null
				
				#timer.start()
				set_state(States.Flying)
			
		States.Flying:
			pass
		_:
			pass

#func _on_timer_timeout() -> void:
	#set_collision_layer_value(2, 1)
