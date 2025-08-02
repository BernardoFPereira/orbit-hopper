extends CharacterBody2D
class_name Player

@export var orbit_target: Node2D
@export var speed := 200

@onready var camera: Camera2D = $"../Camera2D"
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const  WIDTH := 1886
const  HEIGHT := 1999

enum ContactDir { LEFT, RIGHT, FRONT }

enum States {
	Orbit,
	Flying,
	Dead,
}

func set_state(new_state) -> void:
	match new_state:
		States.Orbit:
			camera.target = orbit_target
		States.Dead:
			camera.target = self
			set_collision_layer_value(2, 0)
		_:
			camera.target = self
	
	state = new_state

var state: States = States.Flying
var last_orbit: Node2D
var orbit_clockwise := true
var just_spawned := true

func _process(delta: float) -> void:
	if global_position.x > WIDTH + 50:
		global_position.x = -50
	elif global_position.x < -50:
		global_position.x = WIDTH + 50
		
	if global_position.y > HEIGHT + 50:
		global_position.y = -50
	elif global_position.y < -50:
		global_position.y = HEIGHT + 50

	match state:
		States.Orbit:
			velocity = Vector2.ZERO
			if orbit_target.orbit_speed < 0:
				look_at(orbit_target.global_position)
				rotation += PI
				sprite.play("orbit_left")
			else:
				look_at(orbit_target.global_position)
				sprite.play("orbit_right")
			
		States.Flying:
			sprite.play("flying")
			if orbit_clockwise: 
				velocity = global_transform.basis_xform(Vector2.UP) * speed
			else:
				velocity = global_transform.basis_xform(Vector2.DOWN) * speed
				
			if last_orbit:
				if global_position.distance_to(last_orbit.global_position) > 100 * last_orbit.scale.x:
					set_collision_layer_value(2, 1)
					last_orbit = null
			
		States.Dead:
			var dead_fx = preload("res://Particulas_Igor/ship_explosion.tscn").instantiate()
			
			if get_slide_collision_count() > 0:
				dead_fx.global_transform = global_transform
				dead_fx.emitting = true
				add_sibling(dead_fx)
				call_deferred("queue_free")
			pass
		
	handle_input(delta)
	move_and_slide()

func handle_input(delta):
	match state:
		States.Orbit:
			if Input.is_action_pressed("launch"):
				if orbit_target.orbit_speed >= 0:
					orbit_target.orbit_speed += 0.1
				else:
					orbit_target.orbit_speed -= 0.1
				set_collision_layer_value(2, 0)
				
			if Input.is_action_just_released("launch"):
				reparent(get_tree().root.get_node("Space"))
				
				speed *= orbit_target.orbit_speed / 2
				orbit_target.orbit_speed = 2.0
				last_orbit = orbit_target
				orbit_target = null
				
				set_state(States.Flying)
			
		States.Flying:
			if Input.is_action_pressed("steer"):
				# This doesn't *really* work, but it works. Controls are damaged!
				var mouse_pos = get_local_mouse_position()
				velocity += mouse_pos * (delta * 16)
		_:
			pass

func check_orbit_side(target_pos: Vector2) -> ContactDir:
	if just_spawned:
		just_spawned = false
		return ContactDir.RIGHT
		
	# Get the spaceship's forward direction (assumes -y is forward)
	var forward = -transform.y.normalized()
	var target_dir = global_position.direction_to(target_pos)
	
	# Calculate angle using dot product
	var dot = forward.dot(target_dir)
	var angle_degrees = rad_to_deg(acos(dot))
	
	# If angle is small, target is in front
	if angle_degrees < 18.0:
		return ContactDir.FRONT
		
	# Otherwise, check right/left using cross product
	var cross = forward.cross(target_dir)
	if cross > 0:
		return ContactDir.RIGHT
	else:
		return ContactDir.LEFT
