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

@onready var defense_stat_icon: StatIcon = $UI/HBoxContainer/DefenseStatIcon
@onready var parry_stat_icon: StatIcon = $UI/HBoxContainer/ParryStatIcon


var defense:DefenseComponent
var parry:ParryComponent
var status_conditions:StatusEffectsComponent
var can_move:bool = true

# Updates data and display of entity
func initialize(entity_data:EntityData, starting_health:int = -1):
	super(entity_data, starting_health)
	defense = DefenseComponent.new()
	parry = ParryComponent.new()
	status_conditions = StatusEffectsComponent.new()
	status_conditions.initialize(self, status_parent)
	
	defense.defense_changed.connect(defense_stat_icon.update_ui)
	parry.parry_changed.connect(parry_stat_icon.update_ui)
	
	await get_tree().create_timer(randf_range(0, 0.25)).timeout
	animation_player.play("entity/idle")


# -------------------------------------------------
# Damage & Health functions
# -------------------------------------------------
# Makes the entity lose health and emits relevent signals
# Override in children to add animation logic
func take_damage(amount:float, attacker:BattleEntity = null):
	if is_defeated:
		return
	
	if attacker != null:
		last_attacker = attacker
	
	if can_take_damage:
		var damage:int = status_conditions.apply_damage_effects(amount)
		damage = defense.block_damage(damage)
		
		_health.take_damage(damage)
		damaged.emit(damage)
	else:
		damaged.emit(0)
	
	damage_particles.emitting = true
	animation_player.stop()
	animation_player.play("entity/damage")
	if last_attacker and parry.current_parry > 0:
		animation_player.play("entity/attack")
		await animation_player.animation_finished
		if not attacker.is_defeated:
			attacker.take_damage(parry.use_parry())
	else:
		await animation_player.animation_finished
	animation_player.play("entity/idle")


func get_attack_damage(base_damage:int) -> int:
	return status_conditions.apply_attack_effects(base_damage)


func heal(amount:float):
	super(amount)
	animation_player.play("entity/idle")


func _on_new_turn_started():
	super()
	#defense.set_to_zero()
	#parry.set_to_zero()
	status_conditions.decay_status_effects()

# -------------------------------------------------
# Movement functions
# -------------------------------------------------
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
	animation_player.stop()
	animation_player.play("entity/march")


func _on_arrived():
	animation_player.play("entity/idle")
