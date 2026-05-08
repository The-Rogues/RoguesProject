extends Action
class_name SpendGemAction

@export var spend_amount: int
@export var conditional_action: Action
var gem_behavior: Resource = preload("res://content/cards/greedy_cards/gem_behavior/gem_behavior.tres")
var gem_behavior_script: Script = preload("res://content/cards/greedy_cards/gem_behavior/gem_behavior.gd")

func execute(_context:BattleContext = null, _user:AbstractEntity = null):
	var num: int = get_num_gems(_context.get_player())
	if num < spend_amount:
		return
	spend_gems(spend_amount, _context.get_player())
	await conditional_action.execute(_context, _user)

func get_num_gems(player: PlayerEntity) -> int:
	for i in range(0, player.effects.active_effects.size()):
		if player.effects.active_effects[i].effect == gem_behavior:
			return player.effects.active_effects[i].stack
	return 0

func spend_gems(amount: int, player: PlayerEntity) -> void:
	for i in range(0, player.effects.active_effects.size()):
		if player.effects.active_effects[i].effect == gem_behavior:
			player.effects.active_effects[i].stack -= amount
			player.effects.effect_changed.emit(player.effects.active_effects[i])
			if player.effects.active_effects[i].stack == 0:
				player.effects.remove_effect(gem_behavior_script)
