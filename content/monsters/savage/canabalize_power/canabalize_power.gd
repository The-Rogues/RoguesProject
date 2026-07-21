extends BattlePower
class_name CanabalizePower

@export var enemy_name: String
var battle_context: BattleContext = null

func on_apply(_context:BattleContext):
	_context.creature_manager.enemy_defeated.connect(on_enemy_death)
	battle_context = _context

func on_enemy_death(_defeated: MonsterEntity):
	for i in range(0, battle_context.creature_manager.enemies.size()):
		if battle_context.creature_manager.enemies[i].data.name == enemy_name:
			if !battle_context.creature_manager.enemies[i].health.is_alive:
				continue;
			battle_context.creature_manager.enemies[i].health.set_values(
				battle_context.creature_manager.enemies[i].health.value + 7,
				battle_context.creature_manager.enemies[i].health.max_value + 7
			)
			var new_infection: StatusEffectConfig = StatusEffectConfig.new();
			new_infection.behaviour = InfectedBehavior.new();
			new_infection.duration = -1
			new_infection.stack = 1
			new_infection.turn_entered = false
			battle_context.creature_manager.enemies[i].apply_status_effect(new_infection)
