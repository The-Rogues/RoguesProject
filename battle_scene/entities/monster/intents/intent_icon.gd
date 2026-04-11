extends Control
class_name IntentIcon

@onready var icon: TextureRect = $PanelContainer/MarginContainer/Icon
@onready var amplifier: Label = $Amplifier
@onready var intent_tooltip: IntentToolTip = $IntentTooltip
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var associated_entity:MonsterEntity

func _ready() -> void:
	icon.modulate.a = 0


func initialize(enemy:MonsterEntity):
	associated_entity = enemy
	enemy.intent_chosen.connect(_on_intent_chosen)


func _on_intent_chosen(intent:EnemyMove):
	icon.texture = intent.intent_icon
	amplifier.text = ""
	intent_tooltip.initialize(intent, associated_entity)
	animation_player.play("idle")
	var tween = create_tween()
	tween.tween_property(icon, "modulate:a", 1.0, 0.6)


func resolve():
	var tween = create_tween()
	tween.tween_property(icon, "modulate:a", 0.0, 0.6)
	await tween.finished


func _on_icon_mouse_entered() -> void:
	var pos = intent_tooltip.global_position
	intent_tooltip.visible = true
	intent_tooltip.top_level = true
	intent_tooltip.global_position = pos
	pass # Replace with function body.


func _on_icon_mouse_exited() -> void:
	var pos = intent_tooltip.global_position
	intent_tooltip.visible = false
	intent_tooltip.top_level = false
	intent_tooltip.global_position = pos
	pass # Replace with function body.
