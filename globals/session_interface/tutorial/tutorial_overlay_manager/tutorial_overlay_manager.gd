extends Control
class_name TutorialOverlayManager

var curr_child_idx: int = 0

func play_tutorial() -> void:
	self.visible = true
	var section_overlays = get_children()
	if curr_child_idx != 0:
		section_overlays[curr_child_idx - 1].visible = false
	if curr_child_idx != section_overlays.size():
		section_overlays[curr_child_idx].visible = true
		section_overlays[curr_child_idx].connect_to_button(play_tutorial)
		curr_child_idx += 1
		return
	GameStats.stats_data.tutorial_completed = true
	GlobalSaveManager.save_game_stats(GameStats.stats_data)
	curr_child_idx = 0
	self.visible = false
