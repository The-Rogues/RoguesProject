extends PanelContainer
class_name LootPanel

signal all_rewards_collected
signal selected_card(card_data:CardData)
signal picked_trait(chosen_trait:PersonalityTrait, points:int)

@onready var gold_reward: HBoxContainer = $Elements/Rewards/Gold
@onready var gold_amount: Button = $Elements/Rewards/Gold/Collect

@onready var card_reward: HBoxContainer = $Elements/Rewards/Cards

@onready var item_reward: HBoxContainer = $Elements/Rewards/Item
@onready var item_texture: TextureRect = $Elements/Rewards/Item/TextureRect
@onready var item_button: Button = $Elements/Rewards/Item/Collect

@onready var shared_card_draw: CardLootSelector = $SharedCardDraw
@onready var trait_card_draw: CardLootSelector = $TraitCardDraw
@onready var rewards_collected: Label = $RewardsCollected


func initialize(
	gold:int,
	shared_card_loot:CardPool,
	trait_card_loot:PersonalityData,
	_item:ItemData=null,
):
	gold_amount.text = str(gold)
	gold_reward.visible = true
	
	if _item:
		item_texture.texture = _item.display_texture
		item_button.text = _item.name
		item_reward.visible = true
	
	var shared_cards = shared_card_loot.get_items(3) as Array[CardData]
	var trait_cards:Array[CardData]
	trait_cards.append(trait_card_loot.offensive_trait.card_pool.get_items(1)[0])
	trait_cards.append(trait_card_loot.defensive_trait.card_pool.get_items(1)[0])
	trait_cards.append(trait_card_loot.strategic_trait.card_pool.get_items(1)[0])
	
	shared_card_draw.initialize(shared_cards as Array[CardData], "Shared Cards")
	trait_card_draw.initialize(trait_cards as Array[CardData], "Trait Cards")
	shared_card_draw.visible = false
	trait_card_draw.visible = false


func _on_reward_collected():
	if gold_reward.visible == false and \
			card_reward.visible == false and \
			item_reward.visible == false:
		rewards_collected.visible = true
		all_rewards_collected.emit()


func _on_collect_gold_button_up() -> void:
	gold_reward.visible = false
	GlobalSessionManager.increase_gold(int(gold_amount.text))
	_on_reward_collected()
	pass # Replace with function body.


func _on_collect_cards_button_up() -> void:
	shared_card_draw.visible = true
	card_reward.visible = false
	_on_reward_collected()
	pass # Replace with function body.


func _on_collect_item_button_up() -> void:
	item_reward.visible = false
	_on_reward_collected()
	pass # Replace with function body.


func _on_shared_card_draw_selected_card(card_data: CardData) -> void:
	trait_card_draw.visible = true
	shared_card_draw.visible = false
	selected_card.emit(card_data)
	pass # Replace with function body.


func _on_trait_card_draw_selected_card(card_data: CardData) -> void:
	trait_card_draw.visible = false
	selected_card.emit(card_data)
	pass # Replace with function body.


func _on_shared_card_draw_skipped() -> void:
	trait_card_draw.visible = true
	shared_card_draw.visible = false
	pass # Replace with function body.
