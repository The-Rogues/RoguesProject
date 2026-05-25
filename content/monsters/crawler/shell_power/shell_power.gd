extends BattlePower
class_name ShellPower

@export var enemy_number: int = 0
var enemy: MonsterEntity

func on_apply(_context:BattleContext):
	var turtle_enemies: Array[MonsterEntity]
	for i in range(0, _context.creature_manager.enemies.size()):
		if _context.creature_manager.enemies[i].data.name == "Dragon Turtle":
			print("HERE")
			turtle_enemies.append(_context.creature_manager.enemies[i])
	if (enemy_number + 1) <= turtle_enemies.size():
		
		enemy = turtle_enemies[enemy_number]
		print(enemy)
		
		var thorns: StatusEffectConfig = StatusEffectConfig.new()
		thorns.behaviour = ThornsStatusEffectBehaviour.new()
		thorns.stack = 1
		thorns.duration = -1
		thorns.turn_entered = true
		
		var armor: StatusEffectConfig = StatusEffectConfig.new()
		armor.behaviour = ArmorEffect.new()
		armor.stack = 2
		armor.duration = -1
		armor.turn_entered = false
		
		enemy.apply_status_effect(thorns)
		enemy.apply_status_effect(armor)
		
	else:
		end_power()

func on_turn_entered(_context:BattleContext):
	
	var armor: StatusEffectConfig = StatusEffectConfig.new()
	armor.behaviour = ArmorEffect.new()
	armor.stack = 2
	armor.duration = -1
	armor.turn_entered = false
	
	enemy.apply_status_effect(armor)
