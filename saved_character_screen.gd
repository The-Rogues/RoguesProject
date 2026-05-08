extends Control


@onready var character_result_screen: CharacterScreen = $CharacterResultScreen

func _ready() -> void:
	character_result_screen.initialize()
	GlobalSessionInterface.visible = true
