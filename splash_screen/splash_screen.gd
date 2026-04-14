extends Control

@onready var screen_fade: ScreenFade = $ScreenFade


func _ready() -> void:
	GlobalSessionInterface.visible = false
	await screen_fade.fade_in()
	await get_tree().create_timer(2).timeout
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH, false)
