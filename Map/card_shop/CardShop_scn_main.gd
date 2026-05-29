extends Control


@export var card_shop_data: CardShopData
@export var shop_keeper_varients:Array[Texture2D]

@onready var shop_scroll: ScrollContainer = $ShopContainer/Elements/Panel/ScrollContainer2
@onready var sell_scroll: ScrollContainer = $ShopContainer/Elements/Panel/ScrollContainer

@onready var card_shop_interface1: ShopCardInterface = $ShopContainer/Elements/Panel/ScrollContainer2/VBoxContainer/CardShop
@onready var card_shop_interface2: ShopCardInterface = $ShopContainer/Elements/Panel/ScrollContainer2/VBoxContainer/CardShop2
@onready var card_shop_interface3: ShopCardInterface = $ShopContainer/Elements/Panel/ScrollContainer2/VBoxContainer/CardShop3
@onready var card_sell_interface: ShopCardInterface = $ShopContainer/Elements/Panel/ScrollContainer/CardTransform
@onready var shop_keeper_animator: AnimationPlayer = $ShopKeeper/EntityAnimator
@onready var shop_keeper_sprite: Sprite2D = $ShopKeeper/SpriteRoot/Sprite2D
@onready var card_transform: TransformCard = $CardTransform
@onready var shoop_keeper_dialogue: DialogueText = $CanvasLayer/Control/PanelContainer/ShopKeeperDialogue

#var shop_cards:Array[CardInstance] = []
var shop_cards = {}
var selected_card:CardInstance
var selected_card_index:int = -1
var transform_card:Array[CardInstance] = []
var selected_interface: ShopCardInterface = null

func _ready() -> void:
	
	GlobalSessionInterface.visible = true
	shop_scroll.visible = false
	shop_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sell_scroll.visible = false
	sell_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# reload shop cards if resume
	var run : RunProgress = GlobalSessionManager.run_progress
	print("=== CARD SHOP LOAD CHECK ===")
	print("run null: ", run == null)
	print("shop_save null: ", run.shop_save == null if run else "no run")
	print("generated_cards: ", run.shop_save.generated_cards.size() if run and run.shop_save else 0)
	print("resuming: ", run != null and run.shop_save != null and run.shop_save.generated_cards.size() > 0)
	print("============================")
	var resuming := run!= null and run.shop_save != null
	
	if resuming and run.shop_save.generated_cards.size() > 0:
		shop_cards[card_shop_interface1] = []
		shop_cards[card_shop_interface2] = []
		shop_cards[card_shop_interface3] = []
		for i in range(0, run.shop_save.generated_cards.size()):
			var card: CardData = run.shop_save.generated_cards[i]
			if run.shop_save.purchased_card_names.has(card.name):
				continue
			if i == 0:
				shop_cards[card_shop_interface1].append(CardInstance.new(card))
			elif i < 3:
				shop_cards[card_shop_interface2].append(CardInstance.new(card))
			else:
				shop_cards[card_shop_interface3].append(CardInstance.new(card))
		
		
	else:
		
		if GlobalSessionManager.run_progress.ai_mode:
			shop_cards[card_shop_interface1] = card_shop_data.get_ai_card()
		else:
			shop_cards[card_shop_interface1] = card_shop_data.get_legendary_card()
		shop_cards[card_shop_interface2] = card_shop_data.get_random_cards_from_player_traits(GlobalSessionManager.run_progress.player_data.personality)
		shop_cards[card_shop_interface3] = card_shop_data.get_random_cards(GlobalSessionManager.run_progress.player_data.personality)
		
		
		run.shop_save = ShopSaveData.new()
		for card in shop_cards[card_shop_interface1]:
			run.shop_save.generated_cards.append(card.data)
		for card in shop_cards[card_shop_interface2]:
			run.shop_save.generated_cards.append(card.data)
		for card in shop_cards[card_shop_interface3]:
			run.shop_save.generated_cards.append(card.data)
		GlobalSaveManager.save_run(run)
	
	
	print("=== CARD SHOP SAVE CHECK ===")
	print("shop_save null: ", run.shop_save == null)
	print("generated_cards: ", run.shop_save.generated_cards.size())
	print("save path exists: ", FileAccess.file_exists("res://saves/save_progress.tres"))
	print("============================")
	
	card_shop_interface1.initialize(
		shop_cards[card_shop_interface1]
	)
	card_shop_interface1.selected_card.connect(_on_selected_card)
	
	card_shop_interface2.initialize(
		shop_cards[card_shop_interface2]
	)
	card_shop_interface2.selected_card.connect(_on_selected_card)
	
	card_shop_interface3.initialize(
		shop_cards[card_shop_interface3]
	)
	card_shop_interface3.selected_card.connect(_on_selected_card)


	if run:
		transform_card = GlobalSessionManager.run_progress.player_data.get_cards_as_instances()
	else:
		transform_card = []

	card_sell_interface.initialize(transform_card)
	card_sell_interface.selected_card.connect(_on_selected_card)

	shop_keeper_animator.speed_scale = 0.5
	shop_keeper_animator.play("entity/idle")

	if not shop_keeper_varients.is_empty():
		shop_keeper_sprite.texture = shop_keeper_varients.pick_random()
	shoop_keeper_dialogue.say("Welcome, traveler. Looking to strengthen your deck?")
	


func _on_selected_card(index:int, transaction_type:int, transaction_completed:bool, shop_segment: ShopCardInterface = null) -> void:
	if transaction_type == 0:
		selected_interface = shop_segment
		selected_card = shop_cards[selected_interface][index]
	else:
		selected_card = transform_card[index]

	selected_card_index = index

	if transaction_type == 0:
		_on_buy_card()
	else:
		_on_transform_card()
		shoop_keeper_dialogue.say("The transformation is complete!")
		

func _on_buy_card():
	
	var run := GlobalSessionManager.run_progress
	if !run.player_data.can_buy_card(selected_card.data.shop_price):
		shoop_keeper_dialogue.say("Not enough gold!")
		return
	shoop_keeper_dialogue.say("Interesting choice!")
	
	var resuming := run != null and run.shop_save != null
	if resuming:
		run.shop_save.purchased_card_names.append(selected_card.data.name)
	
	run.player_data.add_card(selected_card.data)
	run.player_data.set_gold(
					run.player_data.gold - selected_card.data.shop_price)
	selected_interface.confirm_transaction(selected_card_index)
	
	selected_card = null
	selected_interface = null
	selected_card_index = -1
	GlobalSaveManager.save_run(run)

func _on_transform_card():
	transform_card = GlobalSessionManager.run_progress.player_data.get_cards_as_instances()
	card_sell_interface.initialize(transform_card)
	var transform_options: Array[CardData] = card_shop_data.random_cards_pool + card_shop_data.shop_unique_pool
	var new_card_data = transform_options.pick_random()
	var new_card_instance := CardInstance.new(new_card_data)
	card_transform.play_transform(selected_card, new_card_instance)
	
	GlobalSessionManager.run_progress.player_data.add_card(new_card_data)
	GlobalSessionManager.run_progress.player_data.set_gold(
					GlobalSessionManager.run_progress.player_data.gold - selected_card.data.transform_price)
	GlobalSessionManager.run_progress.player_data.remove_card(selected_card.data)
	card_sell_interface.confirm_transaction(selected_card_index)
	transform_card = GlobalSessionManager.run_progress.player_data.get_cards_as_instances()
	card_sell_interface.initialize(transform_card)
	
	selected_card = null
	selected_card_index = -1
	

func _on_leave_button_up() -> void:
	shoop_keeper_dialogue.say("Good luck out there!")
	await get_tree().create_timer(1.5).timeout
	GlobalSessionManager.complete_current_room()
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)
	

func _on_shop_button_up() -> void:
	shop_scroll.visible = true
	shop_scroll.mouse_filter = Control.MOUSE_FILTER_STOP

	sell_scroll.visible = false
	sell_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shoop_keeper_dialogue.say("Take a look. Every card here could change your run.")

func _on_transform_button_up() -> void:
	shop_scroll.visible = false
	shop_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE

	sell_scroll.visible = true
	sell_scroll.mouse_filter = Control.MOUSE_FILTER_STOP
	shoop_keeper_dialogue.say("Transformation is a gamble.")
