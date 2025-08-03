extends Control

@onready var space: Node = $"../../.."
@onready var music_player: AudioStreamPlayer = $"../../../MusicPlayer"
@onready var ui_player: AudioStreamPlayer = $"../../../UIPlayer"
@onready var fx_player: AudioStreamPlayer = $"../../../FXPlayer"
@onready var audio_button_label: Label = $NinePatchRect/AudioButton/AudioButtonLabel

var audio_muted := false

func _ready() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if AudioServer.get_bus_volume_linear(bus_idx) < 0.1:
		audio_button_label.text = "audio_off"

func _process(delta: float) -> void:
	if audio_muted:
		audio_button_label.text = "audio off"
	else:
		audio_button_label.text = "audio on"
	
	if Input.is_action_just_pressed("pause"):
		switch_pause()

func _on_continue_button_pressed() -> void:
	switch_pause()

func _on_audio_button_pressed() -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	print(AudioServer.get_bus_volume_linear(bus_idx))
	if !audio_muted:
		AudioServer.set_bus_volume_linear(bus_idx, 0.0)
		audio_button_label.text = "audio off"
		audio_muted = true
	else:
		AudioServer.set_bus_volume_linear(bus_idx, 1.0)
		audio_button_label.text = "audio on"
		audio_muted = false

func _on_quit_button_2_pressed() -> void:
	switch_pause()
	get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")

func switch_pause() -> void:
	if !space.game_won:
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_button_down() -> void:
	ui_player.play()
