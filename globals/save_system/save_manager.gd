extends Node
class_name SaveManager

const SAVE_PATH := "user://saves/save_progress.tres"
const GAME_STATS_SAVE_PATH := "user://saves/stats_save_progress.tres"
const SAVE_DIR := "user://saves/"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_run(p: RunProgress) -> void:
	if p == null:
		return
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)
	ResourceSaver.save(p, SAVE_PATH)


func load_run() -> RunProgress:
	if not FileAccess.file_exists(SAVE_PATH):
		return null
	
	var r = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as RunProgress
	if r and r.initialized:
		return r
	
	return null

func get_or_create() -> RunProgress:
	var p: RunProgress = load_run()
	if p != null:
		return p
	p = RunProgress.new()
	save_run(p)
	return p


func reset() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)


func reset_game_stats() -> void:
	if FileAccess.file_exists(GAME_STATS_SAVE_PATH):
		DirAccess.remove_absolute(GAME_STATS_SAVE_PATH)
		GameStats.stats_data = GameStatsData.new()


func has_game_stats_save() -> bool:
	if FileAccess.file_exists(GAME_STATS_SAVE_PATH):
		return GameStats.stats_data.modified
	return false


func save_game_stats(game_stats:GameStatsData):
	if game_stats:
		game_stats.modified = true
		if not DirAccess.dir_exists_absolute(SAVE_DIR):
			DirAccess.make_dir_absolute(SAVE_DIR)
		ResourceSaver.save(game_stats, GAME_STATS_SAVE_PATH)


func load_game_stats() -> GameStatsData:
	if not FileAccess.file_exists(GAME_STATS_SAVE_PATH):
		return null
	
	var s = ResourceLoader.load(GAME_STATS_SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as GameStatsData
	if s:
		return s
	
	return null
