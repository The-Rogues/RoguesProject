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


signal buffed_defense
signal debuffed_defense
signal buffed_attack
signal debuffed_attack
signal started_moving
signal arrived

@onready var entity_animator:AnimationPlayer = $EntityAnimator
@onready var thought_icon: TextureRect = $UI/ThoughtIcon
@onready var thought_context_popup: ContextPanel = $UI/ThoughtContextPanel

# Used to track how many turns are left before recovering
var defense_status_turn_counter:int = 0
var attack_status_turn_counter:int = 0
# TODO: Create thought_icons to display what buffs and debuffs the entity has


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


func buff_defense(amount:float, turns:int = 3):
	if is_defeated:
		return
	
	print(entity_data.name, " defense buff set for turns: ", turns)
	
	entity_data.defense_amplifier.increase(amount)
	buffed_defense.emit()
	
	if entity_data.defense_amplifier.value < 1:
		defense_status_turn_counter = turns
	else:
		defense_status_turn_counter += turns
	
	# TODO: Create specific animations for buffs and debuffs
	entity_animator.stop()
	entity_animator.play("battle_entity/heal")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")


func debuff_defense(amount:float, turns:int = 3):
	if is_defeated:
		return
	
	print(entity_data.name, " defense debuff set for turns: ", turns)
	
	entity_data.defense_amplifier.reduce(amount)
	debuffed_defense.emit()
	
	if entity_data.defense_amplifier.value > 1:
		defense_status_turn_counter = turns
	else:
		defense_status_turn_counter += turns
	
	entity_animator.stop()
	entity_animator.play("battle_entity/damage")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")


func buff_attack(amount:float, turns:int = 3):
	if is_defeated:
		return
	
	print(entity_data.name, " attack buff set for turns: ", turns)
	
	entity_data.attack_amplifier.increase(amount)
	buffed_attack.emit()
	
	if entity_data.attack_amplifier.value < 1:
		attack_status_turn_counter = turns
	else:
		attack_status_turn_counter += turns
	
	entity_animator.stop()
	entity_animator.play("battle_entity/heal")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")


func debuff_attack(amount:float, turns:int = 3):
	if is_defeated:
		return
	
	print(entity_data.name, " attack debuff set for turns: ", turns)
	
	entity_data.defense_amplifier.reduce(amount)
	debuffed_attack.emit()
	
	if entity_data.attack_amplifier.value > 1:
		attack_status_turn_counter = turns
	else:
		attack_status_turn_counter += turns
	
	entity_animator.stop()
	entity_animator.play("battle_entity/damage")
	await entity_animator.animation_finished
	entity_animator.play("battle_entity/idle")


func _on_defeated():
	super()
	entity_animator.stop()
	entity_animator.play("battle_entity/defeat")
	await entity_animator.animation_finished


func _on_new_turn_started():
	super()
	
	if entity_data.defense_amplifier.value != 1:
		defense_status_turn_counter -= 1
		print(entity_data.name,
				" ", 
				defense_status_turn_counter,  
				" turns left of defense amplifier")
		if defense_status_turn_counter == 0:
			defense_status_turn_counter = 1
			print(entity_data.name,  " reset defense amplifier")
	
	if entity_data.attack_amplifier.value != 1:
		attack_status_turn_counter -= 1
		print(entity_data.name,
				" ", 
				attack_status_turn_counter,  
				" turns left of attack amplifier")
		if attack_status_turn_counter == 0:
			attack_status_turn_counter = 1
			print(entity_data.name,  " reset attack amplifier")


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


func thought_icon_visible(is_visible:bool):
	thought_icon.visible = is_visible


func display_thought_icon():
	thought_icon.visible = true


func hide_thought_icon():
	thought_icon.visible = false


func _on_thought_icon_mouse_entered() -> void:
	if !thought_icon.visible:
		return
	thought_context_popup.visible = true
	pass # Replace with function body.


func _on_thought_icon_mouse_exited() -> void:
	if !thought_icon.visible:
		return
	thought_context_popup.visible = false
	pass # Replace with function body.
