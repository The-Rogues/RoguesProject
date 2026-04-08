extends Control
class_name IntentIcon

@onready var icon: TextureRect = $PanelContainer/MarginContainer/Icon
@onready var amplifier: Label = $Amplifier
@onready var context_panel: ContextPanel = $ContextPanel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	icon.modulate.a = 0


func initialize(enemy:MonsterEntity):
	enemy.intent_chosen.connect(_on_intent_chosen)


func _on_intent_chosen(intent:EnemyMove):
	icon.texture = intent.intent_icon
	amplifier.text = ""
	context_panel.set_context(intent.description)
	animation_player.play("idle")
	var tween = create_tween()
	tween.tween_property(icon, "modulate:a", 1.0, 0.6)


func resolve():
	var tween = create_tween()
	tween.tween_property(icon, "modulate:a", 0.0, 0.6)
	await tween.finished
