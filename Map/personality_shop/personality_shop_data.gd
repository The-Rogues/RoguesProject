extends Resource
class_name PersonalityShopData

@export var shop_keeper_textures: Array[Texture2D]
@export var all_traits: Array[PersonalityTrait]

@export var trait_price: int = 10
@export var random_trait_price: int = 10
@export var base_weight_price: int = 10
@export var offer_count_per_category: int = 3

var weight_buy_count: int = 1

var offensive_offers: Array[PersonalityTrait] = []
var defensive_offers: Array[PersonalityTrait] = []
var strategic_offers: Array[PersonalityTrait] = []


func generate_offers(player_personality: PersonalityData) -> void:
	offensive_offers.clear()
	defensive_offers.clear()
	strategic_offers.clear()

	var offensive_pool: Array[PersonalityTrait] = []
	var defensive_pool: Array[PersonalityTrait] = []
	var strategic_pool: Array[PersonalityTrait] = []

	for t in all_traits:

		if player_has_trait(player_personality, t):
			continue

		match t.trait_category:

			PersonalityTrait.TraitCategory.OFFENSIVE:
				offensive_pool.append(t)

			PersonalityTrait.TraitCategory.DEFENSIVE:
				defensive_pool.append(t)

			PersonalityTrait.TraitCategory.STRATEGIC:
				strategic_pool.append(t)

	offensive_pool.shuffle()
	defensive_pool.shuffle()
	strategic_pool.shuffle()

	for i in range(
		min(offer_count_per_category, offensive_pool.size())
	):
		offensive_offers.append(
			offensive_pool[i]
		)

	for i in range(
		min(offer_count_per_category, defensive_pool.size())
	):
		defensive_offers.append(
			defensive_pool[i]
		)

	for i in range(
		min(offer_count_per_category, strategic_pool.size())
	):
		strategic_offers.append(
			strategic_pool[i]
		)


func pick_traits(pool: Array[PersonalityTrait]) -> Array[PersonalityTrait]:
	var result: Array[PersonalityTrait] = []
	var unique_pool = pool.duplicate()
	unique_pool.shuffle()

	var amount: int = 0

	while not unique_pool.is_empty() and amount < offer_count_per_category:
		result.append(unique_pool.pop_front())
		amount += 1

	return result


func get_random_trait(player_personality: PersonalityData) -> PersonalityTrait:
	var possible_traits: Array[PersonalityTrait] = []

	for t in all_traits:
		if not player_has_trait(player_personality, t):
			possible_traits.append(t)

	if possible_traits.is_empty():
		return null

	return possible_traits.pick_random()


func get_weight_price() -> int:
	return base_weight_price * weight_buy_count


func increase_weight_price() -> void:
	weight_buy_count += 1


func player_has_trait(player_personality: PersonalityData, t: PersonalityTrait) -> bool:
	return (
		player_personality.offensive_trait == t
		or player_personality.defensive_trait == t
		or player_personality.strategic_trait == t
	)
