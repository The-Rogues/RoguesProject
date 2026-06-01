extends BattlePower
class_name IceWarriorResolvePower

@export var strength_amount: int
@export var enemy_name: String
var battle_context: BattleContext = null
var ice_warrior_data: Resource = preload("res://content/monsters/ice_warrior/ice_warrior_data.tres")

func on_apply(_context:BattleContext):
	_context.creature_manager.enemy_defeated.connect(on_enemy_death)
	battle_context = _context

func on_enemy_death(_defeated: MonsterEntity):
	for i in range(0, battle_context.creature_manager.enemies.size()):
		if battle_context.creature_manager.enemies[i].data.name == enemy_name:
			var add_strength: StatusEffectConfig = StatusEffectConfig.new()
			add_strength.behaviour = StrengthEffect.new()
			add_strength.duration = -1
			add_strength.stack = 2
			battle_context.creature_manager.enemies[i].apply_status_effect(add_strength)
