extends Control

@onready var margin_container: MarginContainer = $MarginContainer
@onready var no_save_data_label: Label = $NoSaveDataLabel
@onready var character_image: TextureRect = $MarginContainer/Contents/HBox/CharacterImage
@onready var health_label: Label = $MarginContainer/Contents/HBox/Elements/Container/Health/HealthLabel
@onready var name_label: Label = $MarginContainer/Contents/HBox/Elements/Info/NameLabel
@onready var offensive_trait_display: TraitDisplay = $MarginContainer/Contents/HBox/Elements/Info/OffensiveTraitDisplay
@onready var defensive_trait_display: TraitDisplay = $MarginContainer/Contents/HBox/Elements/Info/DefensiveTraitDisplay
@onready var strategic_trait_display: TraitDisplay = $MarginContainer/Contents/HBox/Elements/Info/StrategicTraitDisplay
@onready var gold_label: Label = $MarginContainer/Contents/HBox/Elements/Container/Gold/GoldLabel


func initialize() -> void:
	var run = GlobalSessionManager.run_progress
	
	if run == null:
		margin_container.visible = false
		no_save_data_label.visible = true
		return
	
	name_label.text = run.player_data.name
	character_image.texture = run.player_texture
	health_label.text = get_player_health_as_string(run.player_data)
	offensive_trait_display._on_trait_data_updated(
		run.player_data.personality.offensive_trait,
		run.player_data.personality.offensive_weight
	)
	
	defensive_trait_display._on_trait_data_updated(
		run.player_data.personality.defensive_trait,
		run.player_data.personality.defensive_weight
	)
	
	strategic_trait_display._on_trait_data_updated(
		run.player_data.personality.strategic_trait,
		run.player_data.personality.strategic_weight
	)
	
	gold_label.text = str(run.player_data.gold)


func get_player_health_as_string(data:PlayerData) -> String:
	return str(data.current_health) + "/" + str(data.max_health)
