extends Control

const CARDS = preload("res://content/items/card_packs/traitless_card_pack.tres")

@export var random_shop_card_count:int = 9
@export var shop_keeper_varients:Array[Texture2D]

@onready var shop_scroll: ScrollContainer = $PanelContainer/ScrollContainer2
@onready var sell_scroll: ScrollContainer = $PanelContainer/ScrollContainer

@onready var card_shop_interface: ShopCardInterface = $PanelContainer/ScrollContainer2/CardShop
@onready var card_sell_interface: ShopCardInterface = $PanelContainer/ScrollContainer/CardSell
@onready var shop_keeper_animator: AnimationPlayer = $ShopKeeper/EntityAnimator
@onready var shop_keeper_sprite: Sprite2D = $ShopKeeper/SpriteRoot/Sprite2D

var shop_cards:Array[CardInstance] = []
var selected_card:CardInstance
var selected_card_index:int = -1
var sell_cards:Array[CardInstance] = []

func _ready() -> void:
	GlobalSessionInterface.visible = true
	shop_scroll.visible = false
	shop_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE

	sell_scroll.visible = false
	sell_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var shuffled_cards = CARDS.card_pool.duplicate()
	shuffled_cards.shuffle()

	for i in range(3):
		shop_cards.append(CardInstance.new(shuffled_cards[i]))
	card_shop_interface.initialize(shop_cards)
	card_shop_interface.selected_card.connect(_on_selected_card)

	if GlobalSessionManager.run_progress:
		sell_cards = GlobalSessionManager.run_progress.player_data.get_cards_as_instances()
	else:
		sell_cards = []

	card_sell_interface.initialize(sell_cards)
	card_sell_interface.selected_card.connect(_on_selected_card)

	shop_keeper_animator.speed_scale = 0.5
	shop_keeper_animator.play("entity/idle")

	if not shop_keeper_varients.is_empty():
		shop_keeper_sprite.texture = shop_keeper_varients.pick_random()


func _on_selected_card(index:int, transaction_type:int, transaction_completed:bool) -> void:
	if transaction_type == 0:
		selected_card = shop_cards[index]
	else:
		selected_card = sell_cards[index]

	selected_card_index = index

	if transaction_type == 0:
		_on_buy_card()
	else:
		_on_sell_card()
		

func _on_buy_card():
	if !GlobalSessionManager.run_progress.player_data.can_buy_card(selected_card.data.shop_price):
		return

	GlobalSessionManager.run_progress.player_data.add_card(selected_card.data)
	GlobalSessionManager.run_progress.player_data.set_gold(
					GlobalSessionManager.run_progress.player_data.gold - selected_card.data.shop_price)
	card_shop_interface.confirm_transaction(selected_card_index)
					
	selected_card = null
	selected_card_index = -1

func _on_sell_card():
	sell_cards = GlobalSessionManager.run_progress.player_data.get_cards_as_instances()
	card_sell_interface.initialize(sell_cards)
	
	GlobalSessionManager.run_progress.player_data.remove_card(selected_card.data)
	GlobalSessionManager.run_progress.player_data.set_gold(
					GlobalSessionManager.run_progress.player_data.gold + selected_card.data.shop_price)
	card_sell_interface.confirm_transaction(selected_card_index)
					
	selected_card = null
	selected_card_index = -1
	

func _on_leave_button_up() -> void:
	GlobalSessionManager.complete_current_room()
	GlobalSceneLoader.load_scene(GlobalSceneLoader.MAP_SCENE_PATH)

func _on_shop_button_up() -> void:
	shop_scroll.visible = true
	shop_scroll.mouse_filter = Control.MOUSE_FILTER_STOP

	sell_scroll.visible = false
	sell_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_sell_button_up() -> void:
	shop_scroll.visible = false
	shop_scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE

	sell_scroll.visible = true
	sell_scroll.mouse_filter = Control.MOUSE_FILTER_STOP
