extends Resource
class_name PersonalityTrait
## Resource that defines traits for [Personality] class, it's behavioural
## properties, and display information
##
## Intended to be used as a creatable asset in the file system that is
## assigned to the personality trait member values of [Personality]

## Displayed when trait is made visible.
@export var trait_icon:Texture2D
## Unique identifier for this type of trait
@export var id:String
## Diaplayed when trait is made visible.
@export var name:String
## Displayed when trait is made visible and mouse is hovered over trait icon.
@export_multiline var description:String
@export var card_pool:CardPool
@export var default_cards:Array[CardData]
