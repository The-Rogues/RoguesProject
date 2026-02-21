extends Control
class_name BattleIntentIcon

@onready var icon: TextureRect = $PanelContainer/MarginContainer/Icon
@onready var amplifier: Label = $Amplifier
@onready var context_panel: ContextPanel = $ContextPanel
var battle_move:BattleMove

func initialize(battle_move:BattleMove):
	icon.texture = battle_move.action_display_icon
	amplifier.text = ""
	context_panel.set_context(battle_move.description)
	self.battle_move = battle_move

func resolve():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
