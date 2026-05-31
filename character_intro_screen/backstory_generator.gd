extends Node

static var OFFENSIVE_FRAGMENTS := {
	"BRUTISH": [
		"Only strength matters in their world.",
		"Finds satisfaction in destruction.",
		"Believes they are the ultimate warrior."
	],

	"TACTICAL": [
		"They were sent to assess the dangers lurking across the landscape",
		"Rumors of a gateway to the heavens drew their attention here.",
		"A survivalist on their next adventure."
	],

	"MERCIFUL": [
		"A quiet calling convinced them their presence was needed here.",
		"They keep an eye out for explorers who have lost their way.",
		"Looking to make some friends with monsters."
	],

	"VENGEFUL": [
		"The monsters of this place once claimed a member of their tribe.",
		"Returned after abandoning an earlier expedition.",
		"A bounty has led them here in pursuit of someone hiding within."
	]
}

static var DEFENSIVE_FRAGMENTS := {
	"CRAFTY": [
		"Working with their hands has always come naturally to them.",
		"Life in the wilderness taught them how to make do with little.",
		"They arrived seeking insperation for their art."
	],

	"STOIC": [
		"Doesn't say much.",
		"Level-headed and perceptive.",
		"Can come off as shrude."
	],

	"NAIVE": [
		"They are convinced that goodness exists within every living thing.",
		"Failure is something they simply don't believe can happen to them.",
		"Reaching the gateway feels like the first step toward becoming a hero."
	],

	"SKITTISH": [
		"They feel something watching them.",
		"Years of teasing from their peers left their confidence shaken.",
		"This journey feels suspiciously like a judgment they cannot avoid."
	]
}

static var STRATEGIC_FRAGMENTS := {
	"FRIENDLY": [
		"Hopes to find companionship among fellow travelers.",
		"Believes in the power of friendship!",
		"Ate a swirly-pop before coming here."
	],

	"GREEDY": [
		"Believes access to the gateway should belong to them.",
		"On the lookout for heavenly treasures.",
		"They are in serious financial debt."
	],

	"LAIDBACK": [
		"They're not too worried about what they'll find.",
		"They might find an abondoned camo to rest in.",
		"Interested in what's edible nearby."
	],

	"VALOROUS": [
		"Seeks the strongest fighters to challenge.",
		"Hopes to prove themselves by making it through.",
		"For the glory of their kingdom."
	]
}

static var ENDINGS := [
	"Wants to destroy the gateway. Only the Lord domain over entering heaven",
	"By making it through, they hope to become a better person.",
	"Wants to be reconciled with their Lord. They're not proud of their actions.",
	"When a member of their Church vanished here, they volunteered to look for them.",
	"Wants to passthrough the gateway as they fear their sins are too great.",
	"At the very least, returning home with a cool harp would make the trip worthwhile."
]


static func generate_backstory(personality: PersonalityData) -> String:
	var offense := personality.offensive_trait.name.to_upper()
	var defense := personality.defensive_trait.name.to_upper()
	var strategic := personality.strategic_trait.name.to_upper()

	var parts: Array[String] = []

	if OFFENSIVE_FRAGMENTS.has(offense):
		parts.append(
			OFFENSIVE_FRAGMENTS[offense].pick_random()
		)

	if DEFENSIVE_FRAGMENTS.has(defense):
		parts.append(
			DEFENSIVE_FRAGMENTS[defense].pick_random()
		)

	if STRATEGIC_FRAGMENTS.has(strategic):
		parts.append(
			STRATEGIC_FRAGMENTS[strategic].pick_random()
		)

	parts.append(
		ENDINGS.pick_random()
	)

	return " ".join(parts)
