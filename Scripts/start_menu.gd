extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/level.tscn")

func _on_credits_button_pressed() -> void:
	print("THERE ARE NO CREBITZ")
	#get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func _on_help_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/howtoplaymenu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_returnto_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")
