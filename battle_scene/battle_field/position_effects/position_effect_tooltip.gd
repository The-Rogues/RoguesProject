extends PanelContainer

@onready var tool_tip_label: RichTextLabel = $ToolTipLabel


func initialize(instance:PositionEffect):
	var _name = instance.data.behaviour.get_effect_name()
	
	var header = "[color=gold]" + _name + "[/color]\n"
	tool_tip_label.text = header + instance.data.behaviour.get_description(instance)
