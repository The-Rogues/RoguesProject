extends Resource
class_name CardShopData

@export var random_cards_pool: Array[CardData]
@export var ai_cards_pool: Array[CardData]


func get_shop_card(player_personality: PersonalityData) -> Array[CardInstance]:
	var shop_cards: Array[CardInstance] = []

	for i in range(3):
		shop_cards.append(CardInstance.new(random_cards_pool.pick_random()))

	var unique_cards = get_random_cards_from_player_traits(player_personality)

	for card in unique_cards:
		shop_cards.append(CardInstance.new(card))

	shop_cards.append(CardInstance.new(ai_cards_pool.pick_random()))

	return shop_cards


func get_random_cards_from_player_traits(
	player_personality: PersonalityData
) -> Array[CardData]:

	var available_traits: Array[PersonalityTrait] = []

	if player_personality.offensive_trait:
		available_traits.append(
			player_personality.offensive_trait
		)

	if player_personality.defensive_trait:
		available_traits.append(
			player_personality.defensive_trait
		)

	if player_personality.strategic_trait:
		available_traits.append(
			player_personality.strategic_trait
		)

	available_traits.shuffle()

	var result: Array[CardData] = []

	var trait_count = min(2, available_traits.size())

	for i in range(trait_count):

		var t = available_traits[i]

		if t.card_loot_pool.is_empty():
			continue

		result.append(
			t.card_loot_pool.pick_random()
		)

	return result
