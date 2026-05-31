extends ApplyStatusAction
class_name RandomApplyStatusAction

@export var random_pool: Array[StatusEffectConfig] 

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	effect = random_pool.pick_random()
	await super(_context, _user)
