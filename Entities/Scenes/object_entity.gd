extends Entity
class_name ObjectEntity

@onready var context_panel: ContextPanel = $UI/ContextPanel

func initialize(entity_data:EntityData, starting_health:int = -1):
	super(entity_data, starting_health)
	health_bar.visible = false


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
	
	if data.attack_filter == ObjectEntityData.AttackFilter.BLOCK or \
			data.attack_filter == ObjectEntityData.AttackFilter.INTERCEPT:
		_health.take_damage(amount)
		health_bar.visible = true
	
	damaged.emit(amount)
	damage_particles.emitting = true
	animation_player.stop()
	animation_player.play("entity/damage")
	await animation_player.animation_finished
	animation_player.play("entity/RESET")


func heal(amount:float):
	super(amount)
	if _health.current_health == _health.max_health:
		health_bar.visible = false
	animation_player.play("entity/RESET")
