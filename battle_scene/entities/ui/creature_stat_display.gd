extends Control
class_name CreatureStatDisplay

@onready var name_label: Label = $Display/NameLabel
@onready var health_bar: HealthBar = $Display/HealthBar
@onready var status_effect_container: StatusEffectsContainer = $Display/StatusEffectContainer
@onready var preference_container: PreferenceContainer = $PreferenceContainer
@onready var block_icon: TextureRect = $BlockIcon
@onready var dialogue: DialogueText = %Dialogue
@onready var dissapear_timer: Timer = $Dialogue/DissapearTimer



func initialize(creature:AbstractCreature):
	name_label.text = creature.data.name
	health_bar.initialize(creature.health)
	status_effect_container.initialize(creature.effects)
	block_icon.initialize(creature.block)
	reparent(creature)
	creature.health.died.connect(remove)
	
	creature.turn_entered.connect(_update_text.bind(creature))
	creature.turn_exited.connect(dialogue.clear)
	dissapear_timer.timeout.connect(_on_dissapear_timer_timeout)


func remove():
	reparent(get_tree().current_scene)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	queue_free()


func toggle_preferences():
	status_effect_container.visible = !status_effect_container.visible
	preference_container.visible = !preference_container.visible


func _update_text(creature:AbstractCreature):
	if randf() >= 0.5:
		if creature is MonsterEntity:
			if !creature.data.speech.is_empty():
				dialogue.say(creature.data.speech.pick_random())
				dissapear_timer.start()


func _on_dissapear_timer_timeout():
	dialogue.text = ""
