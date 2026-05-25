extends Control
class_name PersonalityShop

const PERSONALITY_SLOT = preload("res://Map/personality_shop/UI/personality_shop_slot.tscn")
const RANDOM_PERSONALITY_SLOT = preload("res://Map/personality_shop/UI/random_personality_slot.tscn")

@export var shop_data: PersonalityShopData

@onready var slot_container: HBoxContainer = $ShopContainer/Elements/TraitChange
@onready var shop_keeper_sprite: Sprite2D = $ShopKeeper
@onready var shoop_keeper_dialogue: DialogueText = $CanvasLayer/Control/PanelContainer/ShopKeeperDialogue


func _ready() -> void:
	var run: RunProgress = GlobalSessionManager.run_progress
	var resuming := run != null and run.shop_save != null
	var personality = run.player_data.personality
	
	if resuming and run.shop_save.offensive_offers.size() > 0:
		shop_data.offensive_offers = run.shop_save.offensive_offers
		shop_data.defensive_offers = run.shop_save.defensive_offers
		shop_data.strategic_offers = run.shop_save.strategic_offers
	
	else: 
		run.shop_save = ShopSaveData.new()
		shop_data.generate_offers(personality)
		run.shop_save.defensive_offers = shop_data.offensive_offers
		run.shop_save.defensive_offers = shop_data.defensive_offers
		run.shop_save.strategic_offers = shop_data.strategic_offers
		GlobalSaveManager.save_run(run)
	create_slots()
	shoop_keeper_dialogue.say("Welcome, traveler. Ready to reshape who you are?")


func create_slots() -> void:
	for child in slot_container.get_children():
		child.queue_free()

	await get_tree().process_frame

	var personality = GlobalSessionManager.run_progress.player_data.personality

	_create_slot(
		personality.offensive_trait,
		shop_data.offensive_offers,
		personality.offensive_weight
	)

	_create_slot(
		personality.defensive_trait,
		shop_data.defensive_offers,
		personality.defensive_weight
	)

	_create_slot(
		personality.strategic_trait,
		shop_data.strategic_offers,
		personality.strategic_weight
	)

	create_random_slot()


func _create_slot(
	current_trait: PersonalityTrait,
	offers: Array[PersonalityTrait],
	current_weight: int
) -> void:
	var slot = PERSONALITY_SLOT.instantiate()

	slot_container.add_child(slot)

	slot.initialize(
		current_trait,
		offers,
		current_weight,
		shop_data.get_weight_price()
	)

	slot.trait_selected.connect(_on_trait_selected)
	slot.weight_selected.connect(_on_weight_selected)


func create_random_slot() -> void:
	var slot = RANDOM_PERSONALITY_SLOT.instantiate()

	slot_container.add_child(slot)

	slot.initialize(shop_data.random_trait_price)

	slot.random_trait_bought.connect(_on_random_trait_bought)


func _on_trait_selected(slot: PersonalityShopSlot, t: PersonalityTrait) -> void:
	var player_data = GlobalSessionManager.run_progress.player_data

	if not player_data.can_pay_price(shop_data.trait_price):
		on_not_enough_gold()
		return

	player_data.set_gold(player_data.gold - shop_data.trait_price)

	player_data.personality.set_trait(
		get_category_key(t),
		t
	)

	slot.current_weight = get_weight_for_trait(t)
	slot.update_current(t)
	shoop_keeper_dialogue.say("Your personality has shifted.")


func _on_weight_selected(slot: PersonalityShopSlot, weight: int) -> void:
	var run: RunProgress = GlobalSessionManager.run_progress
	var player_data = run.player_data
	var personality = player_data.personality
	var t = slot.current_trait

	if t == null:
		return

	var cost = shop_data.get_weight_price()

	if not player_data.can_pay_price(cost):
		on_not_enough_gold()
		return
	
	player_data.set_gold(player_data.gold - cost)

	personality.set_trait_weight(
		get_category_key(t),
		weight
	)

	shop_data.increase_weight_price()
	
	if run != null and run.shop_save != null:
		run.shop_save.weight_buy_count = shop_data.weight_buy_count
	slot.current_weight = get_weight_for_trait(t)
	slot.price = shop_data.get_weight_price()
	slot.update_current(t)
	shoop_keeper_dialogue.say("That trait now holds greater influence.")


func _on_random_trait_bought() -> void:
	var player_data = GlobalSessionManager.run_progress.player_data

	if not player_data.can_pay_price(shop_data.random_trait_price):
		on_not_enough_gold()
		return

	var random_trait = shop_data.get_random_trait(player_data.personality)

	if random_trait == null:
		return

	player_data.set_gold(player_data.gold - shop_data.random_trait_price)

	player_data.personality.set_trait(
		get_category_key(random_trait),
		random_trait
	)

	shop_data.generate_offers(player_data.personality)
	create_slots()
	shoop_keeper_dialogue.say("Fate chooses this time.")


func get_category_key(t: PersonalityTrait) -> String:
	match t.trait_category:
		PersonalityTrait.TraitCategory.OFFENSIVE:
			return "OFFENSIVE"
		PersonalityTrait.TraitCategory.DEFENSIVE:
			return "DEFENSIVE"
		PersonalityTrait.TraitCategory.STRATEGIC:
			return "STRATEGIC"

	return ""


func get_weight_for_trait(t: PersonalityTrait) -> int:
	var personality = GlobalSessionManager.run_progress.player_data.personality

	match t.trait_category:
		PersonalityTrait.TraitCategory.OFFENSIVE:
			return personality.offensive_weight
		PersonalityTrait.TraitCategory.DEFENSIVE:
			return personality.defensive_weight
		PersonalityTrait.TraitCategory.STRATEGIC:
			return personality.strategic_weight

	return 1


func on_not_enough_gold() -> void:
	shoop_keeper_dialogue.say("You lack the gold for such change.")


func _on_leave_button_up() -> void:
	shoop_keeper_dialogue.say("Good luck out there!")
	await get_tree().create_timer(1.5).timeout
	GlobalSessionManager.complete_current_room()
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
