#author: andy g
extends PanelContainer
#notes: Volumne does change and stay the same throughout the scene changes but it seems that with every different
# scene comes a new instance of the settings menu. 
var opened = false 

func opened_from_menu(yes:bool) -> void:
	opened = yes

func _on_music_toggled(toggled_on: bool) -> void:
	MusicManager.set_music_enabled(toggled_on)
	


func _on_master_volume_slider_value_changed(value: float) -> void:
	MusicManager.set_master_volume(value)
	


func _on_music_slider_value_changed(value: float) -> void:
	MusicManager.set_music_volume(value)



func _on_back_button_up() -> void:
	visible = false
	
	if(opened):
		get_parent().visible = false
		GlobalSessionInterface.visible = false
	
	opened = false
func _on_ai_mode_toggled(toggled_on: bool) -> void:
	if GlobalSessionManager.run_progress:
		GlobalSessionManager.run_progress.ai_mode = toggled_on

func _on_sound_effects_volume_slider_value_changed(value: float) -> void:
	MusicManager.set_sfx_volume(value)
