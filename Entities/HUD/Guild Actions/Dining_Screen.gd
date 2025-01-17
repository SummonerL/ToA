extends CanvasLayer

# bring in our global constants
onready var constants = get_node("/root/Game_Constants")

# bring in the global player variables
onready var player = get_node("/root/Player_Globals")

# bring in our global action list
onready var global_action_list = get_node("/root/Actions")

# bring in our items
onready var global_items_list = get_node("/root/Items")

# bring in our abilities
onready var global_ability_list = get_node("/root/Abilities")

# bring in our guild variables/functions
onready var guild = get_node("/root/Guild")

# bring in our signals
onready var signals = get_node("/root/Signal_Manager")

# preaload the letters + symbols
onready var letters_symbols_scn = preload("res://Entities/HUD/Letters_Symbols/Letters_Symbols.tscn")
var letters_symbols_node

# various hud scenes
onready var hud_selection_list_scn = preload("res://Entities/HUD/Selection_List.tscn")

# our dining background sprite
onready var dining_background_sprite = get_node("Dine_Background_Sprite")

# out dining icon sprite
onready var dining_icon_sprite = get_node("Dining_Icon_Sprite")

# keep an extra arrow to act as a selector
var selector_arrow

# keep track of the currently selected food item in the dining screen
var current_item_set = []
var current_item = 0
var dining_start_index_tracker = 0
var dining_end_index_tracker = 0

enum DINING_SCREEN_STATES {
	SELECTING_ITEM,
	SELECTING_OPTION
}

var dining_screen_state = DINING_SCREEN_STATES.SELECTING_ITEM

onready var food_actions = [
	global_action_list.COMPLETE_ACTION_LIST.EAT_FOOD_AT_DINING_HALL,
	global_action_list.COMPLETE_ACTION_LIST.VIEW_ITEM_INFO_AT_DINING_HALL
]

# keep track of the active unit
var active_unit

# a tracker for whether to pull from the inventory, or from the depot
var pull_from_inv = false

# text for the dining screen
const DINE_TEXT = 'Dining Hall'
const NO_FOOD_TEXT = "No food at the depot..."
const NO_FOOD_INV_TEXT = "No food in inventory..."
const CAN_NOT_BE_GAINED_MORE_THAN_ONCE_TEXT = "This effect can not be gained more than once. "
const ALREADY_HAS_EFFECT_TEXT = ' already has that effect.'
const CANT_EAT_ANY_MORE_MEALS_TEXT = ' can\'t eat any more meals today...'
const ATE_THE_TEXT = ' ate the '
const NEW_FOOD_EFFECT_ADDED_TEXT = ' New food effect added.'
const IS_NO_LONGER_HUNGRY_TEXT = ' is no longer hungry.'

# keep track of the food items at the depot
var current_food_items = []

func dining_screen_init():
	letters_symbols_node = letters_symbols_scn.instance()
	add_child(letters_symbols_node)
	
	# add ane extra arrow to the screen to act as a selector
	selector_arrow = letters_symbols_node.arrow_right_sprite.duplicate()
	add_child(selector_arrow)
	
	# make sure the letters sit on top
	letters_symbols_node.layer = self.layer + 1
	
	# dampen the background music while we are viewing the unit's information
	get_tree().get_current_scene().dampen_background_music()

func set_source(from_inv):
	pull_from_inv = from_inv
	
	# go ahead and start printing the food items
	populate_food_items()

func set_unit(unit):
	active_unit = unit

func cancel_select_list():
	# start processing input again (unpause this node)
	set_process_input(true)

func populate_header():
	dining_icon_sprite.position = Vector2((constants.DIA_TILES_PER_COL - 2) * constants.DIA_TILE_WIDTH, 1 * constants.DIA_TILE_HEIGHT)

	# print dining text (centered)
	letters_symbols_node.print_immediately(DINE_TEXT, Vector2((constants.TILES_PER_COL) - (floor(len(DINE_TEXT) / 2.0)), 1))

# function for grabbing all of the food items from the depot (adds to current_food_items)
func get_food_items_from_depot():
	current_food_items = []
	
	var guild_items_index = 0
	
	for item in guild.current_items:
		if (item.type == global_items_list.ITEM_TYPES.FISH):
			current_food_items.append({
				"item": item,
				"index": guild_items_index
			})
		
		guild_items_index += 1
		
func get_food_items_from_inv():
	current_food_items = []
	
	var inv_tems_index = 0
	
	for item in active_unit.current_items:
		if (item.type == global_items_list.ITEM_TYPES.FISH):
			current_food_items.append({
				"item": item,
				"index": inv_tems_index
			})
		
		inv_tems_index += 1

func populate_food_items(depot_start_index = 0):
	dining_start_index_tracker = depot_start_index
	
	# first get all of the food items
	if (pull_from_inv):
		get_food_items_from_inv()
	else:
		get_food_items_from_depot()
	
	# clear any letters / symbols
	letters_symbols_node.clearText()
	letters_symbols_node.clear_specials()
	
	# make sure we close the dialogue box as well, if it's present
	player.hud.full_text_destruction()
	
	# go ahead and print the dining text and position the icon
	populate_header()
	
	# hide the selector arrow
	selector_arrow.visible = false
	
	var start_x = 2
	var start_y = 3
	
	dining_end_index_tracker = dining_start_index_tracker + 3
	
	if (dining_end_index_tracker > current_food_items.size() - 1): # account for index
		dining_end_index_tracker = current_food_items.size() - 1
		
	current_item_set = current_food_items.slice(dining_start_index_tracker, dining_end_index_tracker, 1) # only show 4 items at a time
	
	# make the selector arrow visible
	if (current_food_items.size() > 0):
		selector_arrow.visible = true
		selector_arrow.position = Vector2((start_x - 1) * constants.DIA_TILE_WIDTH, (start_y + ((current_item - dining_start_index_tracker) * 2)) * constants.DIA_TILE_HEIGHT)
	else:
		player.hud.dialogueState = player.hud.STATES.INACTIVE
		if (pull_from_inv):
			player.hud.typeTextWithBuffer(NO_FOOD_INV_TEXT, true)
		else:
			player.hud.typeTextWithBuffer(NO_FOOD_TEXT, true)
		
	# print the down / up arrow, depending on where we are in the list of food items
	if (current_item_set.size() >= 4 && (dining_start_index_tracker + 3) < current_food_items.size() - 1): # account for index
		letters_symbols_node.print_special_immediately(constants.SPECIAL_SYMBOLS.DOWN_ARROW, 
			Vector2(((constants.DIA_TILES_PER_ROW - 1) / 2) * constants.DIA_TILE_WIDTH, 10 * constants.DIA_TILE_HEIGHT))
			
	if (dining_start_index_tracker > 0):
		letters_symbols_node.print_special_immediately(constants.SPECIAL_SYMBOLS.UP_ARROW, 
			Vector2(((constants.DIA_TILES_PER_ROW - 1) / 2) * constants.DIA_TILE_WIDTH, 2 * constants.DIA_TILE_HEIGHT))

	for item in current_item_set:
		letters_symbols_node.print_immediately(item.item.name, Vector2(start_x, start_y))
		start_y += 2

func _on_finished_viewing_item_info():
	# since we just finished with the selection list, unpause input in this node
	set_process_input(true)

func show_item_info():
	var item = current_food_items[current_item]
	
	signals.connect("finished_viewing_item_info_dining", self, "_on_finished_viewing_item_info", [], signals.CONNECT_ONESHOT)
	
	# type the item info
	player.hud.dialogueState = player.hud.STATES.INACTIVE
	player.hud.typeTextWithBuffer(item.item.description, false, 'finished_viewing_item_info_dining') 

func _on_already_have_effect_dialogue_completion():
	# since we just finished with the selection list, unpause input in this node
	set_process_input(true)

# actually eat the selected food
func eat_food():
	# give the player the ability
	var food = current_food_items[current_item]
	
	
	var effect = food.item.connected_ability
	
	# display a message if the unit has reached their meal limit
	var meal_count = 0
	for ability in active_unit.unit_abilities:
		if (ability.type == global_ability_list.ABILITY_TYPES.FOOD): 
			# also make sure that the ability isn't 'FED', as that shouldn't take up a meal slot
			if (ability.name != global_ability_list.ABILITY_FED_NAME):
				# if the ability 'doesn't contribute' to the meal limit
				print (ability)
				print (ability.get("contribute_meal_limit"))
				if (ability.get("contribute_meal_limit") == false):
					meal_count += 0
				else:
					meal_count += 1
			
	if (meal_count >= active_unit.meal_limit && (effect.get("contribute_meal_limit") == null || effect.get("contribute_meal_limit") == true)):
		# reuse a signal (it does the same thing)
		signals.connect("already_have_effect_dialogue_dining", self, "_on_already_have_effect_dialogue_completion", [], signals.CONNECT_ONESHOT)
		
		player.hud.dialogueState = player.hud.STATES.INACTIVE
		player.hud.typeTextWithBuffer(active_unit.unit_name + CANT_EAT_ANY_MORE_MEALS_TEXT, false, 'already_have_effect_dialogue_dining') 
		return
	
	# display a message if the user already has this food effect (and the effect is not stackable)
	for ability in active_unit.unit_abilities:
		if (ability.name == effect.name && !food.item.can_stack_effect):
			
			signals.connect("already_have_effect_dialogue_dining", self, "_on_already_have_effect_dialogue_completion", [], signals.CONNECT_ONESHOT)
			
			player.hud.dialogueState = player.hud.STATES.INACTIVE
			player.hud.typeTextWithBuffer(CAN_NOT_BE_GAINED_MORE_THAN_ONCE_TEXT + active_unit.unit_name + ALREADY_HAS_EFFECT_TEXT, 
											false, 'already_have_effect_dialogue_dining') 
			return
	
	# determine if the unit has already eaten today
	var has_eaten = player.party.did_unit_eat(active_unit)
	
	# if they have not eaten, add the 'fed' status
	if (!has_eaten):
		global_ability_list.add_ability_to_unit(active_unit, global_ability_list.ability_fed)
	
	# determine if the unit is hungry, and remove it if so
	var was_hungry = false
	var abil_index = 0 
	for abil in active_unit.unit_abilities:
		if abil.name == global_ability_list.ABILITY_HUNGRY_NAME:
			global_ability_list.remove_ability_from_unit(active_unit, abil, abil_index)
			was_hungry = true
		abil_index += 1
	
	
	# Add the new food effect to the unit, if the unit wasn't hungry. Otherwise, they just become fed
	if (!was_hungry):
		global_ability_list.add_ability_to_unit(active_unit, effect)
		# read the follow-up text
		player.hud.dialogueState = player.hud.STATES.INACTIVE
		player.hud.typeTextWithBuffer(active_unit.unit_name + ATE_THE_TEXT + food.item.name + '.' + NEW_FOOD_EFFECT_ADDED_TEXT, false, 'food_ate_dialogue_dining')
	else:
		# read the follow-up text
		player.hud.dialogueState = player.hud.STATES.INACTIVE
		player.hud.typeTextWithBuffer(active_unit.unit_name + IS_NO_LONGER_HUNGRY_TEXT, false, 'food_ate_dialogue_dining')

	yield(signals, 'food_ate_dialogue_dining')
	
	# remove the item from the depot item list (or the inventory)
	if (pull_from_inv):
		active_unit.current_items.remove(food.index)
		
		# recalculate the current food items
		get_food_items_from_inv()
	else:
		guild.current_items.remove(food.index)
		
		# recalculate the current food items
		get_food_items_from_depot()
	
	# reposition the cursor and repopulate the list, now that we've removed that item
	if (current_item > (current_food_items.size() - 1)):
		if (current_item == dining_start_index_tracker && dining_start_index_tracker > 0):
			dining_start_index_tracker -= 4
		current_item -= 1
		
	populate_food_items(dining_start_index_tracker)

	# since we just finished with the selection list, unpause input in this node
	set_process_input(true)

func close_dining_screen():
	# change the player state
	player.player_state = player.PLAYER_STATE.SELECTING_TILE
	
	# turn the music back up
	get_tree().get_current_scene().heighten_background_music()
	
	# kill ourself :(
	get_parent().remove_child(self)

# a function used on the dining screen to move the currently selected item
func move_items(direction):
	var start_x = 2
	var start_y = 3
	
	if (direction < 0):
		# move up
		if (current_item > dining_start_index_tracker):
			current_item += direction
			selector_arrow.visible = true
			selector_arrow.position = Vector2((start_x - 1) * constants.DIA_TILE_WIDTH, 
				(start_y + ((current_item - dining_start_index_tracker) * 2)) * constants.DIA_TILE_HEIGHT)
			player.hud.full_text_destruction()
		else:
			if (letters_symbols_node.arrow_up_sprite.visible): # if we are allowed to move up
				current_item += direction
				dining_start_index_tracker -= 4
				dining_end_index_tracker = dining_start_index_tracker + 3
				populate_food_items(dining_start_index_tracker)
	else:
		if (current_item < dining_end_index_tracker):
			current_item += direction
			selector_arrow.visible = true
			selector_arrow.position = Vector2((start_x - 1) * constants.DIA_TILE_WIDTH, 
				(start_y + ((current_item - dining_start_index_tracker) * 2)) * constants.DIA_TILE_HEIGHT)
			player.hud.full_text_destruction()
		else:
			if (letters_symbols_node.arrow_down_sprite.visible): # if we are allowed to move down
				current_item += direction
				populate_food_items(dining_end_index_tracker + direction)

func _ready():
	# initialize the dining screen
	dining_screen_init()
	
# input options for the dining screen
func _input(event):
	if (event.is_action_pressed("ui_cancel")):
		close_dining_screen()
		# make sure we close the dialogue box as well, if it's present
		player.hud.clearText()
		player.hud.completeText()
		player.hud.kill_timers()
	if (event.is_action_pressed("ui_down")):
		move_items(1)
	if (event.is_action_pressed("ui_up")):
		move_items(-1)
	if (event.is_action_pressed("ui_accept")):		
		# give the unit the option to 'eat' or view 'info'
		if current_food_items.size() > 0:
			var hud_selection_list_node = hud_selection_list_scn.instance()
			add_child(hud_selection_list_node)
			hud_selection_list_node.layer = self.layer + 1
			hud_selection_list_node.populate_selection_list(food_actions, self, true, false, true) # can cancel, position to the right
			
			# temporarily stop processing input on this node (pause this node)
			set_process_input(false)
