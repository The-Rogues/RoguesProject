extends Control
class_name BattleIntentIcon

@onready var icon: TextureRect = $PanelContainer/MarginContainer/Icon
@onready var amplifier: Label = $Amplifier
@onready var context_panel: ContextPanel = $ContextPanel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var battle_move:BattleMove

func initialize(battle_move:BattleMove):
	icon.texture = battle_move.action_display_icon
	amplifier.text = ""
	context_panel.set_context(battle_move.description)
	self.battle_move = battle_move
	animation_player.play("idle")

func resolve():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	await tween.finished
