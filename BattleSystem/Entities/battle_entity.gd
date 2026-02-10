extends Entity
class_name BattleEntity
## Battle-specific entity node that mediates gameplay logic and presentation.
##
## Extends [Entity] to represent both player characters and enemies during
## combat. Handles damage and healing logic, attack and defense
## amplification, turn-based tracking, movement animation
## sequencing, and combat-related visual feedback.
##
## Serves as the bridge between EntityData state and in-scene representation,
## emitting signals for status changes and coordinating animations in
## response to combat events.


signal started_moving
signal arrived
signal status_condition_added
signal status_condition_removed

@onready var entity_animator:AnimationPlayer = $EntityAnimator
@onready var thought_icon: TextureRect = $UI/ThoughtIcon
@onready var thought_context_popup: ContextPanel = $UI/ThoughtContextPanel
@onready var status_icons_parent: HBoxContainer = $UI/StatusEffect
@onready var star_pop: CPUParticles2D = $StarPop

const STATUS_EFFECT_UI = preload("res://BattleSystem/StatusEffects/status_effect_icon.tscn")
var status_effects: Array[StatusEffect] = []

func initialize(new_entity_data:EntityData = null):
	super(new_entity_data)
	
	started_moving.connect(_on_started_moving)
	arrived.connect(_on_arrived)
	
	# Small delay before idle animation so entities don't move in unison
	var delay = randf_range(0, 0.45)
	await get_tree().create_timer(delay).timeout
	entity_animator.play("battle_entity/idle")

func add_status(effect: StatusEffectData, duration: int = 1, stacks: int = 1):
	for instance in status_effects:
		if instance.effect == effect:
			if effect.is_stackable:
				instance.stack_count += stacks
				instance.duration = max(instance.duration, duration)
			
			for status_icon in status_icons_parent.get_children():
				status_icon.update_ui()
			return
	var instance = StatusEffect.new(effect, duration, stacks)
	status_effects.append(instance)
	effect.on_apply(self, instance)
	var icon = STATUS_EFFECT_UI.instantiate() as StatusEffectIcon
	status_icons_parent.add_child(icon)
	icon.bind(instance)
	icon.update_ui()
	status_condition_added.emit()


func remove_status(instance: StatusEffect):
	instance.effect.on_remove(self, instance)
	status_effects.erase(instance)

	for child in status_icons_parent.get_children():
		if child.instance == instance:
			child.queue_free()
			status_condition_removed.emit()
			break


func get_attack_damage(base: int) -> int:
	var amount := base
	for instance in status_effects:
		amount = instance.effect.modify_outgoing_damage(amount, instance)
	return amount

func take_damage(amount:float, attacker:Entity = null):
	var final_damage:int = amount
	for instance in status_effects:
		final_damage = instance.effect.modify_incoming_damage(final_damage, instance)
	
	super(final_damage, attacker)
	# Stopping animation before playing damage animation for snappy
	# transition
	star_pop.emitting = true
	entity_animator.stop()
	entity_animator.play("battle_entity/damage")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")


func heal(amount:float):
	super(amount)
	entity_animator.stop()
	entity_animator.play("battle_entity/heal")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")


func _on_defeated():
	star_pop.emitting = true
	entity_animator.stop()
	entity_animator.play("battle_entity/defeat")
	await entity_animator.animation_finished
	defeated.emit()
	super()


func _on_new_turn_started():
	super()
	
	for instance in status_effects.duplicate():
		instance.effect.on_turn_start(self, instance)
		instance.duration -= 1
		if instance.duration <= 0:
			remove_status(instance)
	for status_icon in status_icons_parent.get_children():
		status_icon.update_ui()


# Moves the entity to a passed position while playing a walking animation
# Used for animation sequences and moving player between battle positions
func move_to(new_position:Vector2):
	# Tween is a script that changes a passed property over time
	# Tweens finish when the passed paramater reaches a specified value
	var tween = get_tree().create_tween()
	# Interpolate entity position to new position in half a second
	tween.tween_property(self, "global_position", new_position, 0.5)
	started_moving.emit()
	# Waits until entity is at new position
	await tween.finished
	arrived.emit()


func _on_started_moving():
	entity_animator.play("battle_entity/march")


func _on_arrived():
	entity_animator.play("battle_entity/idle")


func update_thought_icon(texture:Texture2D):
	thought_icon.texture = texture

func display_thought_icon():
	thought_icon.visible = true


func hide_thought_icon():
	thought_icon.visible = false
