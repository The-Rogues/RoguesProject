extends BattlePower
class_name RageManagerPower

var player: PlayerEntity
var rage_script: Script = preload("res://content/cards/brute_cards/rage_effect/rage_status_effect.gd")

func on_apply(_context:BattleContext):
	player = _context.get_player()
	player.offensive_trait.updated_trait_weight.connect(_on_offense_modified)

func _on_offense_modified(curr_weight: int):
	if curr_weight == 1:
		player.effects.remove_effect(rage_script)
