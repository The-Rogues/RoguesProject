extends PanelContainer
class_name ToolTip

@onready var tool_tip_label: RichTextLabel = $ToolTipLabel


func set_tooltip(title:String, tip:String, image:Texture2D = null):
	var final_text = "[color=gold]" + title + "[/color]"
	
	if image:
		final_text += "[img]" + image.resource_path + "[/img]"
	
	final_text += "\n" + tip
	
	tool_tip_label.text = final_text
