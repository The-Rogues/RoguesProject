extends PanelContainer

@onready var achievement_icon: TextureRect = %AchievementIcon
@onready var description_label: RichTextLabel = %DescriptionLabel


func initialize(data:AchievementData):
	achievement_icon.texture = data.display_image
	
	var text = "[color=f1b43a]%s[/color]" % data.name
	text += "[color=gray]\n"
	text += "(completed)" if data.completed else "(incomplete)"
	text += "[/color]\n"
	text += data.description
	
	description_label.text = text
	
	if data.completed:
		self_modulate = Color("#a325a8")
	else:
		self_modulate = Color("#343434")
