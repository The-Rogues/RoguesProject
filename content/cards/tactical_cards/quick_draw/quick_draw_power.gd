extends BattlePower
class_name QuickDrawPower

const EFFECT_COUNT = 2
var effect_counter:int = 0

func on_apply(_context:BattleContext):
	_context.get_player().cards.drew_card.connect(_on_card_drawn)


func _on_card_drawn(card:CardInstance):
	if card.data.name == "Reload":
		card.energy_cost = 0
		card.update_instance(null)
		effect_counter += 1
	
	if effect_counter == EFFECT_COUNT:
		end_power()
