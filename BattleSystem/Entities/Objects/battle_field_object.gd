extends Entity
class_name BattleFieldObject

@export var entity_animator:AnimationPlayer

func initialize(new_entity_data:EntityData = null):
	super(new_entity_data)
	update_health_bar()
	updated_entity_data.emit()

# TODO: Fix boiler plate for blocks and ignore functions
func blocks_attacker(attacker:Entity):
	# Unkown attackers are blocked
	if !attacker:
		return true
	
	var attacker_data = attacker.entity_data
	var attacker_is_enemy = attacker_data is EnemyData
	# Checks if object ignores player attacks
	if entity_data.player_attack_filter == BattleObjectData.BlockMode.BLOCK and !attacker_is_enemy:
		return true
	# Checks if object ignores enemy attacks
	if entity_data.enemy_attack_filter == BattleObjectData.BlockMode.BLOCK and attacker_is_enemy:
			return true
	# attack is not blocked
	return false

func ignores_attacker(attacker:Entity):
	# Unkown attackers are never ignored
	if !attacker:
		return false
	
	var attacker_data = attacker.entity_data
	var attacker_is_enemy = attacker_data is EnemyData
	# Checks if object blocks player attacks
	if entity_data.player_attack_filter == BattleObjectData.BlockMode.IGNORE and !attacker_is_enemy:
		return true
	# Checks if object blocks enemy attacks
	if entity_data.enemy_attack_filter == BattleObjectData.BlockMode.IGNORE and attacker_is_enemy:
			return true
	# attack is not ignored
	return false

func take_damage(amount:float, attacker:Entity = null):
	# Checks if the object is ignored when attacked by an entity
	if ignores_attacker(attacker):
		return
	
	entity_animator.stop()
	entity_animator.play("battle_object/damage")
	
	if !entity_data.is_invincible:
		super(amount, attacker)
		update_health_bar()
		#damaged.emit(amount)
	else:
		super(0, attacker)
		#damaged.emit(0)
	
	await entity_animator.animation_finished
	entity_animator.play("battle_object/idle")

func heal(amount:float):
	super(amount)
	entity_animator.stop()
	entity_animator.play("battle_object/heal")
	healed.emit()
	update_health_bar()
	await entity_animator.animation_finished
	entity_animator.play("battle_object/idle")

func _on_defeated():
	super()
	
	entity_animator.stop()
	entity_animator.play("battle_object/defeat")
	await entity_animator.animation_finished

func update_health_bar():
	if entity_data.health.value < entity_data.health.max_value:
		ui_display.visible = true
	elif entity_data.health.value == entity_data.health.max_value:
		ui_display.visible = false

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if entity_data.damaged_by_launch_body:
		if body is LaunchBody:
			take_damage(6)
	else:
		entity_animator.play("battle_object/damage")
	pass # Replace with function body.
