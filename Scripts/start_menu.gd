extends Control

@onready var ui_player: AudioStreamPlayer = $UIPlayer
@onready var main_menu: Control = $MainMenu
@onready var help_menu: Control = $HelpMenu
@onready var credits_menu: Control = $CreditsMenu

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _on_credits_button_pressed() -> void:
	main_menu.visible = false
	help_menu.visible = false
	credits_menu.visible = true

func _on_help_button_pressed() -> void:
	main_menu.visible = false
	help_menu.visible = true
	credits_menu.visible = false

func _on_returnto_main_menu_button_pressed() -> void:
	main_menu.visible = true
	help_menu.visible = false
	credits_menu.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_button_down() -> void:
	ui_player.play()
