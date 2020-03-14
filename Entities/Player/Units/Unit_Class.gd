extends Node

onready var movement_grid_square = preload("res://Entities/Player/Movement_Grid_Square.tscn")
# units can inherit from this class to access common variables

const CANT_MOVE = 999999

# the unit's position on the map
var unit_pos_x = 0
var unit_pos_y = 0

# the unit's base movement (can be modified)
var base_move = 0

# the unit's name
var unit_name = ""

# functions global to all unit types
func show_movement_grid_square(pos_x, pos_y):
	var square = movement_grid_square.instance()
	add_child(square)
	square.set_square_position(pos_x, pos_y)

# calculate all of the eligible tiles the unit can move to, as well as their
# distance. I can't claim to have come up with this 'Spiral' algorithm...
# tbh, I grabbed it off of StackOverflow
func calculate_eligible_tiles():
	# width and height of the range of tiles
	# i.e move 1 = 3x3, move 2 = 5x5
	var sq_size = (base_move*2) + 1 
	
	# current focus. Will start at the "origin", but will be shifted
	# to the actual world map coordinates
	var foc_x = 0 
	var foc_y = 0
	
	# keep track of all the tiles we're iterating over, as well as their distance
	# to the unit
	var tiles = {}
	tiles[String(foc_x) + "_" + String(foc_y)] = 0 # the starting tile, distance of 0

	var change_x = 0
	var change_y = -1
	for _i in range(pow(sq_size,2)):
		# calculate the distance, based on the tile's neighbors
		if (!(foc_x == 0 && foc_y == 0)):
			var shortest_distance = CANT_MOVE # by default, assume we can't move to the tile
			
			if (tiles.get(String(foc_x+1) + "_" + String(foc_y)) != null): # tile to the right
				var neighbor_right_dist = tiles.get(String(foc_x+1) + "_" + String(foc_y))
				if (neighbor_right_dist < shortest_distance):
					shortest_distance = neighbor_right_dist
				
			if (tiles.get(String(foc_x-1) + "_" + String(foc_y)) != null): # tile to the left
				var neighbor_left_dist = tiles.get(String(foc_x-1) + "_" + String(foc_y))
				if (neighbor_left_dist < shortest_distance):
					shortest_distance = neighbor_left_dist
					
			if (tiles.get(String(foc_x) + "_" + String(foc_y-1)) != null): # tile to the north
				var neighbor_up_dist = tiles.get(String(foc_x) + "_" + String(foc_y-1))
				if (neighbor_up_dist < shortest_distance):
					shortest_distance = neighbor_up_dist
				
			if (tiles.get(String(foc_x) + "_" + String(foc_y+1)) != null): # tile to the south
				var neighbor_down_dist = tiles.get(String(foc_x) + "_" + String(foc_y+1))
				if (neighbor_down_dist < shortest_distance):
					shortest_distance = neighbor_down_dist
			
			var new_tile_distance = shortest_distance + 1 # or whatever the movement cost of the tile is
			
			# update the distance of this particular tile
			tiles[String(foc_x) + "_" + String(foc_y)] = new_tile_distance
		
			# shifted to the actual location on map
			if (new_tile_distance <= base_move): # if within the units movement
				show_movement_grid_square(foc_x + unit_pos_x, foc_y + unit_pos_y)
				# DO STUFF...

		if ((foc_x == foc_y) ||
			(foc_x < 0 && foc_x == -foc_y) ||
			(foc_x > 0 && foc_x == 1-foc_y)):
			var temp_c_x = change_x
			var temp_c_y = change_y
			change_x = -temp_c_y
			change_y = temp_c_x
		foc_x += change_x
		foc_y += change_y
