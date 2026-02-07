# Author: Fabian
# Used for displaying and mediating operations on EntityData
# Represents Player and Enemies

extends Entity
class_name BattleEntity

signal buffed_defense
signal debuffed_defense
signal buffed_attack
signal debuffed_attack
signal started_moving
signal arrived
# signal turn_changed
# Animator reference
@export var entity_animator:AnimationPlayer
# Used to display icons over the entities head
# Specific uses are displaying enemy intent and character emotion status
@onready var icon: TextureRect = $UI/Icon
# When Icon is hovered over by mouse, the context panel will display with text
# describing what the icon indicates.
@onready var context_panel: ContextPanel = $UI/ContextPanel
# TODO: Create icons to display what buffs and debuffs the entity has
func initialize(new_entity_data:EntityData = null):
	super(new_entity_data)
	# Initialize amplifier stats
	new_entity_data.defense_amplifier.initialize()
	new_entity_data.attack_amplifier.initialize()
	
	started_moving.connect(_on_started_moving)
	arrived.connect(_on_arrived)
	
	# Small delay before idle animation so entities don't move in unison
	var delay = randf_range(0, 0.45)
	await get_tree().create_timer(delay).timeout
	entity_animator.play("battle_entity/idle")

func take_damage(amount:float, attacker:Entity = null):
	var total_damage = amount
	
	if entity_data.defense_amplifier.value < 1:
		total_damage = total_damage * (1 + entity_data.defense_amplifier.value)
	elif entity_data.defense_amplifier.value > 1:
		total_damage = total_damage * (1 - entity_data.defense_amplifier.value)
	
	super(amount, attacker)
	# Stopping animation before playing damage animation for snappy
	# transition
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

func buff_defense(amount:float):
	if is_defeated:
		return
	
	entity_data.defense_amplifier.increase(amount)
	buffed_defense.emit()
	
	# TODO: Create specific animations for buffs and debuffs
	entity_animator.stop()
	entity_animator.play("battle_entity/heal")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")

func debuff_defense(amount:float):
	if is_defeated:
		return
	
	
	entity_data.defense_amplifier.reduce(amount)
	debuffed_defense.emit()
	
	entity_animator.stop()
	entity_animator.play("battle_entity/damage")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")

func buff_attack(amount:float):
	if is_defeated:
		return
	
	entity_data.attack_amplifier.increase(amount)
	buffed_attack.emit()
	
	entity_animator.stop()
	entity_animator.play("battle_entity/heal")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")

func debuff_attack(amount:float):
	if is_defeated:
		return
	
	entity_data.defense_amplifier.reduce(amount)
	debuffed_attack.emit()
	
	entity_animator.stop()
	entity_animator.play("battle_entity/damage")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")

func _on_defeated():
	super()
	entity_animator.stop()
	entity_animator.play("battle_entity/defeat")
	await entity_animator.animation_finished

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

func update_icon(texture:Texture2D):
	icon.texture = texture

func icon_visible(is_visible:bool):
	icon.visible = is_visible

func display_icon():
	icon.visible = true

func hide_icon():
	icon.visible = false

func _on_icon_mouse_entered() -> void:
	if !icon.visible:
		return
	context_panel.visible = true
	pass # Replace with function body.

func _on_icon_mouse_exited() -> void:
	if !icon.visible:
		return
	context_panel.visible = false
	pass # Replace with function body.
