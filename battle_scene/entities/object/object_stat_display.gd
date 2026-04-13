extends Control
class_name ObjectStatDisplay

@onready var health_bar: HealthBar = $HealthBar
#@onready var interaction_label: Label = $InteractionLabel
@onready var interaction_button: Button = $InteractionButton


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
			interaction_button.text = "Use Key to Interact"
			interaction_button.button_up.connect(object.interact)
			object.player_entered.connect(
				func():
					_on_player_entered(object))
			object.player_exited.connect(_on_player_exited)
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
		object.data.interaction == ObjectData.InteractionOption.BUTTON_WITH_KEY):
		interaction_button.visible = true


func _on_player_exited():
	interaction_button.visible = false
