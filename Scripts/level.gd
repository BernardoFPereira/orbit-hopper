extends Node

@onready var black_hole: Node2D = $BlackHole
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var camera: Camera2D = $Camera2D
@onready var time_left_label: Label = $CanvasLayer/HUD/TimeLeft

const  WIDTH := 1886
const  HEIGHT := 1999
#const TIMER_FMT := ">>> T - % <<<"

var time_left := 120.0

func _ready() -> void:
	var accepted_planet_data = generate_planet_spawn_data(18)
	generate_planets(accepted_planet_data)

func _process(delta) -> void:
	time_left -= delta
	world_environment.environment.glow_intensity = 0.8 * black_hole.scale.x
	if time_left < 110:
		camera.shake(black_hole.scale.x * 0.5)
	
	time_left_label.text = ">>> T - %0.2f <<<" % time_left

func generate_planet_spawn_data(amount: int) -> Array:
	var spawn_point: Vector2
	var accepted_planet_data := []
	
	while len(accepted_planet_data) < amount:
		spawn_point = Vector2(randf_range(100, WIDTH - 100), randf_range(100, HEIGHT - 100))
		var planet_scale = randf_range(0.5, 2.5)
		
		var is_overlapping = false
		for e in accepted_planet_data:
			if Geometry2D.is_point_in_circle(spawn_point, e[0], 200 * e[1]):
				print("NOT ALLOWED AT: %v" % spawn_point)
				is_overlapping = true
				break
		
		if !is_overlapping:
			accepted_planet_data.append([spawn_point, planet_scale])
		
	return accepted_planet_data

func generate_planets(accepted_planet_data: Array) -> void:
	var planet_obj = preload("res://Scenes/Planet.tscn")
	var special_planets := 0
	
	for e in accepted_planet_data:
		var rand_tint = Color(randi_range(0, 255),randi_range(0, 255),randi_range(0, 255))
		var planet = planet_obj.instantiate()
		planet.transform.origin = e[0]
		planet.scale = Vector2(e[1], e[1])
		planet.rotate(rad_to_deg(randf_range(0, 359)))
		planet.self_modulate = rand_tint
		
		if planet.scale.x < 1.4 and special_planets < 2:
			planet.special = true
			special_planets += 1
		
		self.add_child(planet)

#func generate_stars_data(planets_data: Array, amount: int) -> Array:
	#var spawn_point: Vector2
	#var accepted_star_data := []
	#
	#while len(accepted_star_data) < amount:
		#spawn_point = Vector2(randf_range(100, WIDTH - 100), randf_range(100, HEIGHT - 100))
		#var planet_scale = randf_range(0.5, 2.5)
		#
		#var is_overlapping = false
		#for pos in accepted_star_data:
			#if Geometry2D.is_point_in_circle(spawn_point, pos[0], 200):
				#print("NOT ALLOWED AT: %v" % spawn_point)
				#is_overlapping = true
				#break
		#
		#if !is_overlapping:
			#accepted_star_data.append([spawn_point, planet_scale])
		#
	#return accepted_star_data

#func generate_stars() -> void:
	#pass
