extends "res://Entities/Player/Units/Unit_Class.gd"

onready var ps = preload("res://Sprites/characters/woodworker_male_portrait1.png")

# keep track of all the unique dialogue for this charater
const CANT_FISH_WITHOUT_ROD_TEXT = 'Am I supposed to do that with my hands?'
const NO_MORE_FISH_TEXT = 'I don\'t see any more fish here.' 

const CANT_WOODCUT_WITHOUT_AXE_TEXT = 'How am I supposed to do that without an axe?'
const NO_MORE_WOOD_TEXT = 'Hmm... No more wood here.'

const CANT_MINE_WITHOUT_PICKAXE_TEXT = 'I didn\'t even bring a pickaxe... I should just stay in my lane.'
const NO_MORE_ORE_TEXT = 'There\'s nothing else here...'

const CANT_TAP_WITHOUT_TAPPER_TEXT = 'I\'m going to need a tree tapper if I want to do that...'

const NOTHING_HERE_GENERIC_TEXT = "Nope... Nothing."

const INVENTORY_FULL_TEXT = 'I probably shouldn\'t try to carry anything else...'

const NOT_SKILLED_ENOUGH_TEXT = 'I need to get better at this first...'

const WAKE_UP_TEXT = 'I wish I could just sleep in...'
const BED_TIME_TEXT = 'Finally... Time for bed.'
const HUNGRY_TEXT = 'How could I forget to eat yesterday?'

const TOWER_CLIMB_TEXT = "Well, I'd be lying if I said I wasn't impressed by this view."

func unit_init():	
	unit_portrait_sprite = ps

	unit_sprite_node = get_node("Woodworker_Male_Sprite")
	
	unit_id = 5

	unit_name = "Sawyer"
	unit_class = "Woodworker"
	
	age = 35
	
	unit_bio = "Hey... I\'m Sawyer. Frankly, there's not a lot to say about me, but I try to do the best I can with my craft."
	unit_bio += " We\'ll get along as long as you don\'t interrupt me while I\'m working."
	
	base_move = 3
	
	item_mounting_representation = global_items_list.item_sawyer_mount_representation
	
	skill_levels[constants.WOODWORKING] = 5
	
	# give the male woodworker some starting items
	global_items_list.add_item_to_unit(self, global_items_list.item_handsaw)
	global_items_list.add_item_to_unit(self, global_items_list.item_jumbofish)
	
	# add the unit's starting ability
	starting_ability = global_ability_list.ability_concentration
	global_ability_list.add_ability_to_unit(self, global_ability_list.ability_concentration)
	
	self.global_position = Vector2(unit_pos_x*constants.TILE_WIDTH, 
									unit_pos_y*constants.TILE_HEIGHT)
	
func _ready():
	unit_base_init()
	unit_init()
