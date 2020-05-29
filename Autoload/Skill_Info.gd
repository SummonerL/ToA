extends Node

# variables functions for keeping track of skill information,
# such as level requirements, recipes, etc.

# bring in our constants
onready var constants = get_node("/root/Game_Constants")

# bring in our items
onready var global_item_list = get_node("/root/Items")

enum UNLOCK_TYPES {
	RECIPE,
	ABILITY,
	RESOURCE,
	TOOL,
	ANIMAL,
	LIMIT,
	ACTION,
}

# global list of skill unlocks
onready var SKILL_UNLOCKS = {
	# fishing
	constants.FISHING: [
		{
			'unlock_text': ' can now catch Jumbofish!',
			'can_text': 'Catch',
			'skill_info_text': 'Jumbofish',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 1,
		}
	],
	
	
	# woodcutting
	constants.WOODCUTTING: [
		{
			'unlock_text': ' can now chop Cedar Trees!',
			'can_text': 'Chop',
			'skill_info_text': 'Cedar Trees',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 1,
		},
		{
			'unlock_text': ' can now chop Ash Trees!',
			'can_text': 'Chop',
			'skill_info_text': 'Ash Trees',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 2,
		},
		{
			'unlock_text': ' can now chop Fir Trees!',
			'can_text': 'Chop',
			'skill_info_text': 'Fir Trees',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 3,
		},
		{
			'unlock_text': ' can now chop Birch Trees!',
			'can_text': 'Chop',
			'skill_info_text': 'Birch Trees',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 4,
		}
	],
	
	
	# mining
	constants.MINING: [
		{
			'unlock_text': ' can now use a Sturdy Pickaxe!',
			'can_text': 'Use',
			'skill_info_text': 'Sturdy Pickaxe',
			'single_line': true,
			'type': UNLOCK_TYPES.TOOL,
			'level_required': 1,
		},
		{
			'unlock_text': ' can now mine for Stone!',
			'can_text': 'Mine',
			'skill_info_text': 'Stone',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 1,
		},
		{
			'unlock_text': ' can now mine for Amethyst!',
			'can_text': 'Mine',
			'skill_info_text': 'Amethyst',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 1,
		},
		{
			'unlock_text': ' can now mine for Iron Ore!',
			'can_text': 'Mine',
			'skill_info_text': 'Iron Ore',
			'single_line': true,
			'type': UNLOCK_TYPES.RESOURCE,
			'level_required': 3,
		},
	],
	
	
	
	
	

	# woodworking
	constants.WOODWORKING: [
		{
			'can_text': 'Craft',
			'skill_info_text': 'Wooden Handle',
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 1,
			'item': global_item_list.item_wooden_handle,
			'no_tool_required': true,
			'resources_required': [
				{
					'item': global_item_list.item_cedar_logs,
					'quantity': 1
				}
			]
		},
		{
			'unlock_text': ' can now craft Flexible Rods!',
			'can_text': 'Craft',
			'skill_info_text': 'Flexible Rod',
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 2,
			'item': global_item_list.item_flexible_rod,
			'resources_required': [
				{
					'item': global_item_list.item_ash_logs,
					'quantity': 2
				}
			]
		},
		{
			'unlock_text': ' can now craft Wooden Baskets!',
			'can_text': 'Craft',
			'skill_info_text': 'Wooden Basket',
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 2,
			'item': global_item_list.item_wooden_basket,
			'resources_required': [
				{
					'item': global_item_list.item_ash_logs,
					'quantity': 2
				}
			]
		},
		{
			'unlock_text': ' can now craft Wooden Stilts!',
			'can_text': 'Craft',
			'skill_info_text': 'Wooden Stilts',
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 3,
			'item': global_item_list.item_wooden_stilts,
			'resources_required': [
				{
					'item': global_item_list.item_fir_logs,
					'quantity': 2
				}
			]
		},
		{
			'unlock_text': ' can now craft Wooden Pipes!',
			'can_text': 'Craft',
			'skill_info_text': 'Wooden Pipe',
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 3,
			'item': global_item_list.item_wooden_pipe,
			'resources_required': [
				{
					'item': global_item_list.item_cedar_logs,
					'quantity': 2
				}
			]
		},
		{
			'unlock_text': ' can now craft Birdhouses!',
			'can_text': 'Craft',
			'skill_info_text': 'Birdhouse',
			'single_line': true,
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 3,
			'item': global_item_list.item_birdhouse,
			'resources_required': [
				{
					'item': global_item_list.item_birch_logs,
					'quantity': 2
				}
			]
		},
		{
			'unlock_text': ' can now craft Walking Sticks!',
			'can_text': 'Craft',
			'skill_info_text': 'Walking Stick',
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 5,
			'item': global_item_list.item_walking_stick,
			'resources_required': [
				{
					'item': global_item_list.item_hardwood,
					'quantity': 2
				}
			]
		}
	],
	

	# smithing
	constants.SMITHING: [
		{
			'can_text': 'Craft',
			'skill_info_text': 'Sturdy Axe',
			'single_line': true,
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 1,
			'item': global_item_list.item_sturdy_axe,
			'no_tool_required': true,
			'resources_required': [
				{
					'item': global_item_list.item_wooden_handle,
					'quantity': 1
				},
				{
					'item': global_item_list.item_stone,
					'quantity': 2
				},
			]
		},
		{
			'can_text': 'Craft',
			'skill_info_text': 'Sturdy Pickaxe',
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 1,
			'item': global_item_list.item_sturdy_pickaxe,
			'no_tool_required': true,
			'resources_required': [
				{
					'item': global_item_list.item_wooden_handle,
					'quantity': 1
				},
				{
					'item': global_item_list.item_stone,
					'quantity': 2
				},
			]
		},
		{
			'can_text': 'Craft',
			'skill_info_text': 'Hammer',
			'single_line': true,
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 2,
			'item': global_item_list.item_hammer,
			'no_tool_required': true,
			'resources_required': [
				{
					'item': global_item_list.item_wooden_handle,
					'quantity': 1
				},
				{
					'item': global_item_list.item_stone,
					'quantity': 2
				},
			]
		},
		{
			'can_text': 'Craft',
			'skill_info_text': 'Handsaw',
			'single_line': true,
			'type': UNLOCK_TYPES.RECIPE,
			'level_required': 2,
			'item': global_item_list.item_handsaw,
			'no_tool_required': true,
			'resources_required': [
				{
					'item': global_item_list.item_wooden_handle,
					'quantity': 1
				},
				{
					'item': global_item_list.item_stone,
					'quantity': 2
				},
			]
		},
	],
	
	# beast mastery
	constants.BEAST_MASTERY: [
		{
			'unlock_text': ' can now tame one animal per day!',
			'can_text': 'Tame',
			'skill_info_text': '1 Beast Per Day',
			'single_line': false,
			'type': UNLOCK_TYPES.LIMIT,
			'level_required': 1,
		},
		{
			'unlock_text': ' can now pet cats!',
			'can_text': 'Pet',
			'skill_info_text': 'Cats',
			'single_line': true,
			'type': UNLOCK_TYPES.ACTION,
			'level_required': 1,
		},
		{
			'unlock_text': ' can now tame doves!',
			'can_text': 'Tame',
			'skill_info_text': 'Doves',
			'single_line': true,
			'type': UNLOCK_TYPES.ANIMAL,
			'level_required': 3,
		}	
	],
	
	# diplomacy
	constants.DIPLOMACY: [
		{
			'unlock_text': ' can now meet with diplomatic leaders!',
			'can_text': 'Meet With',
			'skill_info_text': 'Diplomatic Leaders',
			'single_line': false,
			'type': UNLOCK_TYPES.ACTION,
			'level_required': 1,
		},
		{
			'unlock_text': ' can now speak Goblintongue!',
			'can_text': 'Speak',
			'skill_info_text': 'Goblintongue',
			'single_line': true,
			'type': UNLOCK_TYPES.LIMIT,
			'level_required': 5,
		},
	],
}

const beast_mastery_tame_restrictions = {
	1: 1 # tame one beast per day at level 1
}

# MISC XP GAINS
const PET_CAT_XP = 2
