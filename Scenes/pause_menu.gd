extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		switch_pause()

func _on_continue_button_pressed() -> void:
	switch_pause()

func _on_audio_button_pressed() -> void:
	pass # TODO: Toggle audio

func _on_quit_button_2_pressed() -> void:
	switch_pause()
	get_tree().change_scene_to_file("res://Scenes/Menus/start_menu.tscn")

func switch_pause() -> void:
		get_tree().paused = !get_tree().paused
		visible = !visible
