extends Control
class_name CreatureStatDisplay

@onready var name_label: Label = $Display/NameLabel
@onready var health_bar: HealthBar = $Display/HealthBar
@onready var status_effect_container: StatusEffectsContainer = $Display/StatusEffectContainer
@onready var preference_container: PreferenceContainer = $PreferenceContainer
@onready var block_icon: TextureRect = $BlockIcon



func initialize(creature:AbstractCreature):
	name_label.text = creature.data.name
	health_bar.initialize(creature.health)
	status_effect_container.initialize(creature.effects)
	block_icon.initialize(creature.block)
	reparent(creature)
	creature.health.died.connect(remove)


func remove():
	reparent(get_tree().current_scene)
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	await tween.finished
	queue_free()

func toggle_preferences():
	status_effect_container.visible = !status_effect_container.visible
	preference_container.visible = !preference_container.visible
