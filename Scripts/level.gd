extends Node

@onready var black_hole: Node2D = $BlackHole
@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var camera: Camera2D = $Camera2D

@onready var time_left_label: Label = $CanvasLayer/HUD/TimeLeft
@onready var fuel_label: Label = $CanvasLayer/HUD/FuelPanel/FuelLabel

@onready var end_game_menu: Control = $CanvasLayer/HUD/EndGameMenu
@onready var win_menu: Control = $CanvasLayer/HUD/WinMenu

@export var GAME_TIME := 120.0
@export var FUEL_CELLS_TO_WIN := 5

const  WIDTH := 1886
const  HEIGHT := 1999

var fuel_cells_collected := 0
var time_left := GAME_TIME
var game_won := false
var game_lost := false

func _ready() -> void:
	var accepted_planet_data = generate_planet_spawn_data(18)
	generate_planets(accepted_planet_data)

func _process(delta) -> void:
	if time_left < 0:
		game_lost = true
		end_game_menu.visible = true
	
	world_environment.environment.glow_intensity = 0.6 * black_hole.scale.x
	if game_won:
		time_left = 0
		time_left_label.label_settings.font_color = Color.AQUAMARINE
	else:
		time_left_label.label_settings.font_color = Color.from_string("#d04a43", Color.CRIMSON)
		time_left -= delta
		
	if time_left < GAME_TIME - 20 and !game_won:
		camera.shake(black_hole.scale.x * 0.5)
		pass
	
	time_left_label.text = ">>> T - %0.2f <<<" % time_left if time_left > 0 else ">>> T + %0.2f <<<" % abs(time_left)
	fuel_label.text = "fuel cells: %s/5" % fuel_cells_collected
	
	if fuel_cells_collected >= FUEL_CELLS_TO_WIN:
		win_menu.visible = true
		game_won = true

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
		#var rand_tint = Color(randi_range(0, 255),randi_range(0, 255),randi_range(0, 255))
		var planet = planet_obj.instantiate()
		planet.transform.origin = e[0]
		planet.scale = Vector2(e[1], e[1])
		planet.rotate(rad_to_deg(randf_range(0, 359)))
		#planet.self_modulate = rand_tint
		
		if planet.scale.x < 1.4 and special_planets < 2:
			planet.special = true
			special_planets += 1
		
		# pegar 5 numeros aleatorios
		# usar eles como index da lista de planetas
		# set planet.contains_fuel = true
		
		self.add_child(planet)

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")

func _on_end_game_timer_timeout() -> void:
	game_lost = true
	end_game_menu.visible = true
