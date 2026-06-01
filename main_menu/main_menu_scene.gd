extends Control
## Handles UI navigation for the main menu by toggling different elements as
## visible.
##
## Author: Nathaniel Stirret
## Editor: Fabian

@onready var main_menu: VBoxContainer = %MainMenu
@onready var start_menu: VBoxContainer = %StartMenu
@onready var credits_menu: VBoxContainer = %CreditsMenu
@onready var settings_menu: PanelContainer = %SettingsMenu
@onready var closing_label: Label = %ClosingLabel
@onready var save_warning_popuo: PanelContainer = %SaveWarningPopuo
@onready var main_menu_selector: Control = %MainMenuSelector
@onready var achievements_screen: Control = %AchievementsScreen
@onready var achievements_return_button: Button = %AchievementsReturnButton
@onready var delete_save_warning: PanelContainer = %DeleteSaveWarning
@onready var delete_data: Button = %DeleteData
@onready var prologue: VBoxContainer = %Prologue
@onready var title_header: MarginContainer = %TitleHeader
@onready var return_prologue: Button = %ReturnPrologue


@onready var continue_game: Button = %Continue
@onready var new_game: Button = %NewGame

@onready var start: Button = %Start
@onready var return_credits: Button = %ReturnCredits


# -------------------------------------------------
# Ready & Initialization
# -------------------------------------------------

func _ready() -> void:
	# Useful for when this scene is transitioned to from a game session
	GlobalSessionInterface.visible = false
	
	# Ensure only main menu is visible
	main_menu.visible = true
	settings_menu.visible = false
	credits_menu.visible = false
	closing_label.visible = false
	start_menu.visible = false
	
	continue_game.set_disabled(!GlobalSaveManager.has_save())
	delete_data.disabled = !GlobalSaveManager.has_game_stats_save()
	
	MusicManager.change_song(MusicManager.track_list.main_menu)
	main_menu_selector.focus_reticle(start)

# -------------------------------------------------
# Main Menu Navigation
# -------------------------------------------------

# View Start Menu
func _on_start_clicked() -> void:
	main_menu.visible = false
	start_menu.visible = true
	await get_tree().process_frame
	main_menu_selector.focus_reticle(new_game)


# View Options Menu
func _on_options_clicked() -> void:
	settings_menu.visible = true


# View Creits Menu
func _on_credits_clicked() -> void:
	credits_menu.visible = true
	main_menu.visible = false
	main_menu_selector.focus_reticle.call_deferred(return_credits)
	pass # Replace with function body.


# View and execute closing game sequence
func _on_close_clicked() -> void:
	closing_label.visible = true
	main_menu.visible = false
	await get_tree().create_timer(3).timeout
	get_tree().quit()
	pass # Replace with function body.


# -------------------------------------------------
# Credits Menu Navigation
# -------------------------------------------------

# Navigate back to Main Menu from Credits Menu
func _on_close_credits_button_up() -> void:
	credits_menu.visible = false
	main_menu.visible = true
	main_menu_selector.focus_reticle(start)
	pass # Replace with function body.

# -------------------------------------------------
# Start Menu Navigation
# -------------------------------------------------

# Navigate back to Main Menu from Start Menu
func _on_return_to_main_menu() -> void:
	start_menu.visible = false
	title_header.visible = true
	main_menu.visible = true
	pass # Replace with function body.


# Transition into continue game scene from Start Menu
func _on_continue_game_clicked() -> void:
	GlobalSessionManager.initialize_map()
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	GlobalSessionInterface.visible = true


# Transition into new game scene from Start Menu
func _on_new_game_clicked() -> void:
	if !GlobalSaveManager.has_save():
		GlobalSaveManager.reset()
		GlobalSessionManager.run_progress = null
		GlobalSceneLoader.load_scene(GlobalSceneLoader.New_Game_Scene)
	else:
		save_warning_popuo.visible = true


# -------------------------------------------------
# Save Data Detected Warning Navigation
# -------------------------------------------------

func _on_yes_button_up() -> void:
	GlobalSaveManager.reset()
	GlobalSessionManager.run_progress = null
	GlobalSceneLoader.load_scene(GlobalSceneLoader.New_Game_Scene)


func _on_no_button_up() -> void:
	save_warning_popuo.visible = false


# -------------------------------------------------
# Achievements Screen
# -------------------------------------------------

func _on_achievements_button_up() -> void:
	main_menu.visible = false
	achievements_screen.visible = true
	main_menu_selector.focus_reticle(achievements_return_button)


func _on_achievements_return_button_button_up() -> void:
	achievements_screen.visible = false
	main_menu.visible = true
	main_menu_selector.focus_reticle(start)
	pass # Replace with function body.

# -------------------------------------------------
# Delete All Data
# -------------------------------------------------

func _on_delete_all_data_button_up() -> void:
	delete_save_warning.visible = true


func _on_yes_delete_all_data_button_up() -> void:
	Achievements.reset_achievements()
	GlobalSaveManager.reset()
	GlobalSaveManager.reset_game_stats()
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)


func _on_no_delete_all_data_button_up() -> void:
	delete_save_warning.visible = false


func _on_prologue_button_up() -> void:
	main_menu.visible = false
	title_header.visible = false
	prologue.visible = true
	await get_tree().process_frame
	main_menu_selector.focus_reticle(return_prologue)


func _on_return_prologue_button_up() -> void:
	main_menu.visible = true
	title_header.visible = true
	prologue.visible = false
	main_menu_selector.focus_reticle(start)
	pass # Replace with function body.
