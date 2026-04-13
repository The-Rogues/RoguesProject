extends Control
class_name DefeatedScreen

@onready var run_summary_label: RichTextLabel = $RunSummaryLabel
@onready var end_run: Button = $"EndRun"


func initialize():
	var run:RunProgress = GlobalSessionManager.run_progress
	
	if run:
		var name_text := "Rogue: [color=gold]" + str(run.player_data.name) + "[/color].\n"
		var rooms := "Room: [color=gold]" + str(run.total_rooms_explored) + "[/color].\n"
		var gold := "Total Gold: [color=gold]" + str(run.total_gold_collected) + "[/color].\n"
		var cards := "Total Cards: [color=gold]" + str(run.total_cards_collected) + "[/color].\n"
		var items := "Total Items: [color=gold]" + str(run.total_items_collected) + "[/color].\n"
		
		run_summary_label.text = name_text + rooms + gold + cards + items
		end_run.disabled = false



func _on_end_run_button_up() -> void:
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAIN_MENU_PATH)
	pass # Replace with function body.
