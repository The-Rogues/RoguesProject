extends Action
class_name WitchDoctorHealAction

var new_zombie_data: MonsterData = preload("res://content/monsters/witch_doctor/the_infected_alt.tres")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	for i in range(0, _context.creature_manager.enemies.size()):
		if _context.creature_manager.enemies[i].data.name == "Zombie":
			_context.creature_manager.enemies[i].health.set_values(
				_context.creature_manager.enemies[i].health.value + 30,
				_context.creature_manager.enemies[i].health.max_value + 30
			)
			_context.creature_manager.enemies[i].data = new_zombie_data
