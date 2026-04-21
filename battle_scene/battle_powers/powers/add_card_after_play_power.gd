extends BattlePower
class_name AddCardAfterPlayPower

@export var card:CardData
@export var play_threshold = 3
var times_played:int = 0


func on_apply(_context:BattleContext):
	_context.get_player().played_card.connect(
		func(_card:CardInstance):
			_on_card_played(_card, _context.get_player()))


func _on_card_played(_card:CardInstance, player:PlayerEntity):
	if _card.data.name == "Charge Shot":
		times_played += 1
		
		if times_played == play_threshold:
			var instance = CardInstance.new(card)
			player.cards.shuffle_card_into_discard_pile(instance)
			times_played = 0
