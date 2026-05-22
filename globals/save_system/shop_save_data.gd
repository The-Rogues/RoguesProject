extends Resource
class_name ShopSaveData


# item shop
@export var generated_items: Array[ItemData] = []
@export var purchased_item_names: Array[String] = []

# card shop
@export var generated_cards: Array[CardData] = []
@export var purchased_card_names: Array[String] = []

# personality shop
@export var offensive_offers: Array[PersonalityTrait] = []
@export var defensive_offers: Array[PersonalityTrait] = []
@export var strategic_offers: Array[PersonalityTrait] = []
@export var weight_buy_count: int = 1
