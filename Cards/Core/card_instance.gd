extends RefCounted
class_name CardInstance

enum Type {ATTACK, SKILL, MOVEMENT, OBJECT, ABILITY}
var type:Type
var stack:int
var cost:int
var data:CardData

func _init(
	card_data:CardData
) -> void:
	data = card_data
	cost = card_data.energy_cost
	stack = 0

func modify_base(base:int):
	return max(base + stack, 1)

func modify_cost(amount:int):
	cost = max(cost + amount, 0)

func execute(battle:BattleManager, _user:BattleEntity=null):
	match data.primary_action:
		AttackAction:
			var action:AttackAction = data.primary_action.duplicate(true)
			action.base_damage = max(action.base_damage + stack, 1)
			action._execute(battle, _user)
		SkillAction:
			pass
	pass
