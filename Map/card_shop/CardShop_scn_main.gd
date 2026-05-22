extends Control


@export var card_shop_data: CardShopData
@export var shop_keeper_varients:Array[Texture2D]

@onready var shop_scroll: ScrollContainer = $ShopContainer/Elements/Panel/ScrollContainer2
@onready var sell_scroll: ScrollContainer = $ShopContainer/Elements/Panel/ScrollContainer

@onready var card_shop_interface: ShopCardInterface = $ShopContainer/Elements/Panel/ScrollContainer2/CardShop
@onready var card_sell_interface: ShopCardInterface = $ShopContainer/Elements/Panel/ScrollContainer/CardTransform
@onready var shop_keeper_animator: AnimationPlayer = $ShopKeeper/EntityAnimator
@onready var shop_keeper_sprite: Sprite2D = $ShopKeeper/SpriteRoot/Sprite2D
@onready var card_transform: TransformCard = $CardTransform
@onready var shoop_keeper_dialogue: DialogueText = $CanvasLayer/Control/PanelContainer/ShopKeeperDialogue

var shop_cards:Array[CardInstance] = []
var selected_card:CardInstance
var selected_card_index:int = -1
var transform_card:Array[CardInstance] = []

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
		print("resuming")
		for card in run.shop_save.generated_cards:
			print(card.name)
			if run.shop_save.purchased_card_names.has(card.name):
				continue
			shop_cards.append(CardInstance.new(card))
	else:
		shop_cards = card_shop_data.get_shop_card(run.player_data.personality)
		run.shop_save = ShopSaveData.new()
		for card in shop_cards:
			run.shop_save.generated_cards.append(card.data)
		GlobalSaveManager.save_run(run)
	print("=== CARD SHOP SAVE CHECK ===")
	print("shop_save null: ", run.shop_save == null)
	print("generated_cards: ", run.shop_save.generated_cards.size())
	print("save path exists: ", FileAccess.file_exists("res://saves/save_progress.tres"))
	print("============================")
	card_shop_interface.initialize(shop_cards)
	card_shop_interface.selected_card.connect(_on_selected_card)

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
	


func _on_selected_card(index:int, transaction_type:int, transaction_completed:bool) -> void:
	if transaction_type == 0:
		selected_card = shop_cards[index]
	else:
		selected_card = transform_card[index]

	selected_card_index = index

	if transaction_type == 0:
		_on_buy_card()
		shoop_keeper_dialogue.say("Interesting choice!")
	else:
		_on_transform_card()
		shoop_keeper_dialogue.say("The transformation is complete!")
		

func _on_buy_card():
	var run := GlobalSessionManager.run_progress
	if !run.player_data.can_buy_card(selected_card.data.shop_price):
		return
	var resuming := run != null and run.shop_save != null
	if resuming:
		run.shop_save.purchased_card_names.append(selected_card.data.name)
	
	run.player_data.add_card(selected_card.data)
	run.player_data.set_gold(
					run.player_data.gold - selected_card.data.shop_price)
	card_shop_interface.confirm_transaction(selected_card_index)
					
	selected_card = null
	selected_card_index = -1
	GlobalSaveManager.save_run(run)

func _on_transform_card():
	transform_card = GlobalSessionManager.run_progress.player_data.get_cards_as_instances()
	card_sell_interface.initialize(transform_card)
	var new_card_data = card_shop_data.random_cards_pool.pick_random()
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
