extends Resource
class_name TrackList

@export var main_menu:AudioStream
@export var new_game_scene:AudioStream
@export var map_scene:AudioStream
@export var early_map_theme:AudioStream
@export var mid_game_map_theme:AudioStream
@export var late_game_map_theme:AudioStream
@export var victory_theme:AudioStream
@export var defeated_theme:AudioStream
@export var shop_theme:AudioStream
@export var battle_theme_varients:Array[AudioStream]
#@export var shop_theme:AudioStream


func choose_battle_theme() -> AudioStream:
	return battle_theme_varients.pick_random()


func choose_map_theme() -> AudioStream:
	var run := GlobalSessionManager.run_progress
	
	if run:
		if run.total_rooms_explored <= 3:
			return early_map_theme
		elif run.total_rooms_explored <= 8:
			return mid_game_map_theme
		else:
			return late_game_map_theme
	
	return early_map_theme
