extends PanelContainer


func _on_music_toggled(toggled_on: bool) -> void:
	MusicManager.set_music_enabled(toggled_on)
	pass # Replace with function body.


func _on_master_volume_slider_value_changed(value: float) -> void:
	MusicManager.set_master_volume(value)
	pass # Replace with function body.


func _on_music_slider_value_changed(value: float) -> void:
	MusicManager.set_music_volume(value)
	pass # Replace with function body.


func _on_back_button_up() -> void:
	visible = false
	pass # Replace with function body.


func _on_ai_mode_toggled(toggled_on: bool) -> void:
	if GlobalSessionManager.run_progress:
		GlobalSessionManager.run_progress.ai_mode = toggled_on


func _on_sound_effects_volume_slider_value_changed(value: float) -> void:
	MusicManager.set_sfx_volume(value)
