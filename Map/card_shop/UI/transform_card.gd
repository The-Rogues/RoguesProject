extends Control
class_name TransformCard

const CARDS = preload("res://content/items/card_packs/traitless_card_pack.tres")

@onready var old_card_ui: Card = $HBoxContainer/OldCard
@onready var new_card_ui: Card = $HBoxContainer/NewCard


func _ready() -> void:
	visible = false


func play_transform(
	old_card: CardInstance,
	final_card: CardInstance
) -> void:
	visible = true

	old_card_ui.initialize(old_card)

	old_card_ui.interaction_mode = false
	new_card_ui.interaction_mode = false

	old_card_ui.modulate.a = 1.0
	new_card_ui.modulate.a = 1.0


	# RANDOMIZE ANIMATION HERE
	await randomize_card_animation(final_card)

	await get_tree().create_timer(1.0).timeout

	visible = false


func randomize_card_animation(
	final_card: CardInstance
) -> void:

	var random_cards = CARDS.card_pool

	# rapidly swap random cards
	for i in range(15):

		var random_card_data: CardData = random_cards.pick_random()

		var random_instance := CardInstance.new(
			random_card_data
		)

		new_card_ui.initialize(random_instance)

		# slows near end
		await get_tree().create_timer(
			0.05 + i * 0.01
		).timeout

	# FINAL CARD
	new_card_ui.initialize(final_card)

	# little pop animation
	new_card_ui.scale = Vector2(1.2, 1.2)

	var tween := create_tween()

	tween.tween_property(
		new_card_ui,
		"scale",
		Vector2.ONE,
		0.15
	)
