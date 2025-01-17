extends Node

# bring in our global constants
onready var constants = get_node("/root/Game_Constants")

# bring in our global action list
onready var global_action_list = get_node("/root/Actions")

# keep track of the global player variables
onready var player = get_node("/root/Player_Globals")

# bring in our guild variables/functions
onready var guild = get_node("/root/Guild")

# bring in our abilities
onready var global_ability_list = get_node("/root/Abilities")

# all of the unit types
onready var angler_male_scn = preload("res://Entities/Player/Units/Angler_Male.tscn")
onready var angler_female_scn = preload("res://Entities/Player/Units/Angler_Female.tscn")
onready var woodcutter_male_scn = preload("res://Entities/Player/Units/Woodcutter_Male.tscn")
onready var woodcutter_female_scn = preload("res://Entities/Player/Units/Woodcutter_Female.tscn")
onready var woodworker_male_scn = preload("res://Entities/Player/Units/Woodworker_Male.tscn")
onready var woodworker_female_scn = preload("res://Entities/Player/Units/Woodworker_Female.tscn")
onready var miner_male_scn = preload("res://Entities/Player/Units/Miner_Male.tscn")
onready var miner_female_scn = preload("res://Entities/Player/Units/Miner_Female.tscn")

# keep track of all the nodes in our party
var party_members = []

# keep track of the unit that is currently 'active'
var active_unit = null

# keep track of which units have yet to act this turn
var yet_to_act = []

func get_all_units():
	return get_children()

func get_active_unit():
	return active_unit
	
func set_active_unit(unit):
	active_unit = unit
	
func reset_yet_to_act():
	yet_to_act = []
	for unit in party_members:
		if (unit.unit_awake && unit.unit_mounting == null):
			yet_to_act.append(unit)
			
	# append animals as well
	for animal in guild.guild_animals:
		if (animal.unit_awake):
			yet_to_act.append(animal)

func remove_from_yet_to_act(unit_id):
	var index = 0
	var final_index = index
	var found = false
	
	for unit in yet_to_act:
		if (unit.unit_id == unit_id):
			final_index = index
			found = true
		index += 1
		
	if (final_index >= 0 && found):
		yet_to_act.remove(final_index)

func empty_yet_to_act():
	yet_to_act = []

func reset_daily_variables():
	for unit in party_members:
		unit.reset_daily_vars()

# function for determining if a unit is asleep at these coordinates
func is_unit_asleep_at(x, y):
	var is_asleep_here = false
	for unit in party_members:
		if (!unit.unit_awake && unit.unit_pos_x == x && unit.unit_pos_y == y):
			is_asleep_here = true
	return is_asleep_here

# useful function for determining if a unit is at these coordinates
func is_unit_here(x, y):
	var is_here = false
	for unit in party_members:
		if (unit.unit_pos_x == x && unit.unit_pos_y == y):
			is_here = true
			
	# check for animals as well
	for animal in guild.guild_animals:
		if (animal.unit_pos_x == x && animal.unit_pos_y == y):
			is_here = true
			
	return is_here
		

func reset_unit_actions():
	for unit in party_members:
		# mounted units will not 'reset' they stay in their current state until DISMNT is selected (from the animal)
		if (unit.get("unit_mounting") == null):
			unit.reset_action_list()
			# also make sure we update their 'acted' state for the new turn
			unit.set_has_acted_state(false)
		
	# reset animals
	for animal in guild.guild_animals:
		animal.reset_action_list()
		# also make sure we update their 'acted' state for the new turn
		animal.set_has_acted_state(false)

func did_unit_eat(unit):
	var ate = false
	for ability in unit.unit_abilities:
		if (ability.type == global_ability_list.ABILITY_TYPES.FOOD): # this unit has a food effect, therefore they ate
			ate = true
	
	return ate
		

func is_unit_hungry(unit):
	var hungry = false
	
	for ability in unit.unit_abilities:
		if (ability.name == global_ability_list.ABILITY_HUNGRY_NAME): # this unit has has the hungry effect
			hungry = true
			
	return hungry
# remove all food abilities from each unit
func remove_abilities_of_type(type):
	
	for unit in party_members:
		var gained_abilities = []
		var index = 0
		var unit_abilities = unit.unit_abilities.duplicate()
		for ability in unit_abilities:

			if (ability.type == type):
				gained_abilities += global_ability_list.remove_ability_from_unit(unit, ability, index)
				index -= 1
				
			index += 1
		
		unit.unit_abilities += gained_abilities # any new abilities the unit may have gained as a result of doing this

# every morning, the inn locations should be removed from each unit's shelter locations (and cave locations as well)
func remove_inn_locations():
	for unit in party_members:
		if (unit.active_inn):
			unit.active_inn.occupants = [] # clear the occupants
		if (unit.active_cave):
			unit.active_cave.occupants = [] # clear the occupants
			
		unit.active_inn = null # set the active_inn to null
		unit.active_cave = null # set the active_cave to null
		
		var index = 0
		for location in unit.shelter_locations:
			if (location == global_action_list.COMPLETE_ACTION_LIST.RETURN_TO_INN):
				unit.shelter_locations.remove(index)
				break
			elif (location == global_action_list.COMPLETE_ACTION_LIST.RETURN_TO_CAVE):
				unit.shelter_locations.remove(index)
				break
			index += 1

# useful function for returning a single unit at given coordinates
func get_unit_at_coordinates(target_x, target_y):
	var target_unit = null
	# first check party members
	for unit in party_members:
		if (unit.unit_pos_x == target_x && unit.unit_pos_y == target_y && unit.unit_awake):
			target_unit = unit
			
	# then check animals
	for animal in guild.guild_animals:
		if (animal.unit_pos_x == target_x && animal.unit_pos_y == target_y && animal.unit_awake):
			target_unit = animal
			
	return target_unit

# useful function to return all of the units that are asleep, specifically at the guild hall
func get_all_units_sleeping_at_guild_hall():
	var at_guild_units = []
	for unit in party_members:
		if (unit.unit_pos_x == player.guild_hall_x && unit.unit_pos_y == player.guild_hall_y):
			at_guild_units.append(unit)
	return at_guild_units

func calculate_total_skill_level():
	var total_skill_level = 0
	for unit in party_members:
		for key in unit.skill_levels:
			total_skill_level += unit.skill_levels[key]
			
	return total_skill_level

func reset_shaders():
	for unit in party_members:
		unit.remove_used_shader()
		
	# reset animal shaders
	for animal in guild.guild_animals:
		animal.remove_used_shader()

func add_unit(unit):
	match unit:
		constants.UNIT_TYPES.ANGLER_MALE:
			var angler_male_node = angler_male_scn.instance()
			add_child(angler_male_node)
			party_members.append(angler_male_node)
		constants.UNIT_TYPES.ANGLER_FEMALE:
			var angler_female_node = angler_female_scn.instance()
			add_child(angler_female_node)
			party_members.append(angler_female_node)
	
		constants.UNIT_TYPES.WOODCUTTER_MALE:
			var woodcutter_male_node = woodcutter_male_scn.instance()
			add_child(woodcutter_male_node)
			party_members.append(woodcutter_male_node)
		constants.UNIT_TYPES.WOODCUTTER_FEMALE:
			var woodcutter_female_node = woodcutter_female_scn.instance()
			add_child(woodcutter_female_node)
			party_members.append(woodcutter_female_node)
		constants.UNIT_TYPES.WOODWORKER_MALE:
			var woodworker_male_node = woodworker_male_scn.instance()
			add_child(woodworker_male_node)
			party_members.append(woodworker_male_node)
		constants.UNIT_TYPES.WOODWORKER_FEMALE:
			var woodworker_female_node = woodworker_female_scn.instance()
			add_child(woodworker_female_node)
			party_members.append(woodworker_female_node)
		constants.UNIT_TYPES.MINER_MALE:
			var miner_male_node = miner_male_scn.instance()
			add_child(miner_male_node)
			party_members.append(miner_male_node)
		constants.UNIT_TYPES.MINER_FEMALE:
			var miner_female_node = miner_female_scn.instance()
			add_child(miner_female_node)
			party_members.append(miner_female_node)
