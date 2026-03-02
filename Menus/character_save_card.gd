extends NinePatchRect
class_name CharacterSaveCard

@onready var texture_rect: TextureRect = $Margin/Elements/Character/TextureRect
@onready var character_name: Label = $Margin/Elements/Character/About/Name
@onready var traits_display: TraitDisplay = $Margin/Elements/Character/About/TraitsDisplay
@onready var current_health: Label = $Margin/Elements/Health/CurrentHealth
@onready var no_save_data: Label = $NoSaveData
@onready var margin: MarginContainer = $Margin
@onready var player_gold: Label = $Margin/Elements/Gold/PlayerGold


func initialize():
	if GlobalSessionManager.run_progress:
		character_name.text = GlobalSessionManager.run_progress.character_entity_data.name
		traits_display.initialize(GlobalSessionManager.run_progress.personality_data)
		current_health.text = str(GlobalSessionManager.run_progress.current_health) + "/" + str(GlobalSessionManager.run_progress.character_entity_data.max_health)
		texture_rect.texture = GlobalSessionManager.get_character_texture()
		player_gold.initialize()
		margin.visible = true
		no_save_data.visible = false
	else:
		margin.visible = false
		no_save_data.visible = true
