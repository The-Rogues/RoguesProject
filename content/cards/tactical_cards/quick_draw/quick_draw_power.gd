extends BattlePower
class_name QuickDrawPowerNew

@export var draw_amnt: int
var normal_draw_count: int = 0
var player: PlayerEntity = null

func on_apply(_context:BattleContext):
	player = _context.get_player()
	player.cards.drew_card.connect(_on_card_drawn)
	for i in range(0, draw_amnt):
		await player.cards.draw_cards(1)
	player.cards.drew_card.disconnect(_on_card_drawn)
	end_power()

func _on_card_drawn(card:CardInstance):
	if card.data.name == "Agile Shot" || card.data.name == "Charge Shot" || card.data.name == "Arrow Shot":
			player.cards.draw_cards(1)
