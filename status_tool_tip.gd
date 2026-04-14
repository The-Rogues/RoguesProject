extends PanelContainer
class_name StatusToolTip

@onready var tool_tip_label: RichTextLabel = $ToolTipLabel


func initialize(instance:ActiveStatusEffect):
	var path = instance.effect.get_texture().resource_path
	var _name = ""
	
	var header = "[color=gold]" + _name + "[/color][img]" + path + "[/img]\n"
	tool_tip_label.text = header + instance.effect.get_description(instance)
