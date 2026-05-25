extends Control


@onready var achievement_icon: TextureRect = %AchievementIcon
@onready var description_label: RichTextLabel = %DescriptionLabel
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	Achievements.achievement_unlocked.connect(on_achievement_unlocked)


func on_achievement_unlocked(data:AchievementData):
	achievement_icon.texture = data.display_image
	var text = "[color=gold]%s[/color]\n[color=gray](Completed)[/color]" % data.name
	description_label.text = text
	
	animation_player.play("show_unlock")
