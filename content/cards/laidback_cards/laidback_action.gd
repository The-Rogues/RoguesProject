extends BlockAction
class_name LaidBackAction

enum EffectType {
	STORED_POWER,
	CALM_GUARD,
	PATIENT_BLOW
}

@export var effect_type: EffectType

# Stored Power
@export var energy_next_turn:int = 1
@export var draw_amount:int = 1

# Calm Guard
@export var block_amount:int = 8
@export var boosted_block:int = 12

# Patient Blow
@export var damage:int = 6
@export var boosted_damage:int = 16


func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	if not _user:
		return
	
	match effect_type:
		EffectType.STORED_POWER:
			execute_stored_power(_context, _user)
		
		EffectType.CALM_GUARD:
			execute_calm_guard(_context, _user)
		
		EffectType.PATIENT_BLOW:
			execute_patient_blow(_context, _user)


func execute_stored_power(_context:BattleContext, _user:AbstractEntity):
	# Gain 1 extra energy next turn
	_user.energy.add_bonus_energy(energy_next_turn)
	
	## If did not attack last turn, draw 1 card
	#if not _user.attacked_last_turn:
	#	_user.cards.draw_cards(draw_amount)


func execute_calm_guard(_context:BattleContext, _user:AbstractEntity):
	amount = block_amount
	
	# If unused energy last turn, gain more block
	if _user.unused_energy_last_turn > 0:
		amount = boosted_block
	super.execute(_context, _user)


func execute_patient_blow(_context:BattleContext, _user:AbstractEntity):
	var final_damage = damage
	
	# If did not attack last turn, deal more damage
	if not _user.attacked_last_turn:
		final_damage = boosted_damage
	
	var patient_attack: AttackAction = AttackAction.new()
	patient_attack.base_damage = final_damage
	patient_attack.target_option = TargetedAction.TargetOption.ENEMY
	await patient_attack.execute(_context, _user)
	#final_damage = _user.effects.apply_attack_damage_effects(final_damage)
	
	#for target in resolved_targets:
	#	if is_instance_valid(target):
	#		target.take_damage(final_damage, _user)
