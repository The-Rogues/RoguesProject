extends Node
class_name SaveManager

const SAVE_PATH := "res://saves/save_progress.tres"

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_run(p: RunProgress) -> void:
	if p == null:
		return
	ResourceSaver.save(p, SAVE_PATH)

func load_run() -> RunProgress:
	if not FileAccess.file_exists(SAVE_PATH):
		return null
	
	var r = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE) as RunProgress
	if r != null && r.initialized:
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
