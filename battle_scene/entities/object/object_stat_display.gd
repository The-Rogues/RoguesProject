extends Control
class_name ObjectStatDisplay

@onready var health_bar: HealthBar = $HealthBar
#@onready var interaction_label: Label = $InteractionLabel
@onready var interaction_button: Button = $InteractionButton
@onready var preference_container: PreferenceContainer = $PreferenceContainer
var can_interact:bool = true

func initialize(object:ObjectEntity):
	health_bar.initialize(object.health)
	#object.health.health_changed.connect(_on_health_changed)
	health_bar.visible = true
	interaction_button.visible = false
	
	match object.data.interaction:
		ObjectData.InteractionOption.ON_HIT:
			pass
			#interaction_label.text = "Hit"
		ObjectData.InteractionOption.BUTTON:
			#interaction_label.text = "Get Close"
			interaction_button.text = "Interact"
			interaction_button.button_up.connect(object.interact)
		ObjectData.InteractionOption.BUTTON_WITH_KEY:
			#interaction_label.text = "Get Close"
			
			connect_button_to_player(object)
			
			interaction_button.text = "Use Key to Interact"
			interaction_button.button_up.connect(func():
					if !can_interact:
						return 
					var run = GlobalSessionManager.run_progress
					
					if run:
						var key = run.player_data.get_key_item("open_chest")
						if key:
							run.player_data.remove_item(key)
					object.interact()
					interaction_button.visible = false
					can_interact = false)
			object.player_entered.connect(
				func():
					_on_player_entered(object))
			
			object.player_exited.connect(_on_player_exited)
			check_chest(object)
		ObjectData.InteractionOption.ON_ENTERED_TURN:
			pass
		ObjectData.InteractionOption.NONE:
			#interaction_button.text = ""
			interaction_button.visible = false
			object.player_entered.connect(
				func():
					_on_player_entered(object))
			object.player_exited.connect(_on_player_exited)


func _on_health_changed(current:int, max:int):
	health_bar.visible = current > 0


func _on_player_entered(object:ObjectEntity):
	if (object.data.interaction == ObjectData.InteractionOption.BUTTON or
		object.data.interaction == ObjectData.InteractionOption.BUTTON_WITH_KEY
		and can_interact):
		interaction_button.visible = true
	else:
		interaction_button.visible = false


func _on_player_exited():
	interaction_button.visible = false


func connect_button_to_player(object:ObjectEntity):
	var run = GlobalSessionManager.run_progress
	
	if run:
		run.player_data.items_updated.connect(func(_items):
			check_chest(object))


func check_chest(object:ObjectEntity):
	if object.data.can_open_chest():
		interaction_button.disabled = false
		interaction_button.text = "Use Key to open"
	else:
		interaction_button.text = "Need Key to open"
		interaction_button.disabled = true
		
		interaction_button.disabled = !object.data.can_open_chest()
