extends PanelContainer

@onready var tool_tip_label: RichTextLabel = $ToolTipLabel


func initialize(data:ObjectData):
	var _name = data.name
	
	var header = "[color=gold]" + _name + "[/color]\n"
	tool_tip_label.text = header + data.hover_description
