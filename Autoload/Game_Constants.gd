extends Node2D

const TILE_HEIGHT = 16
const TILE_WIDTH = 16
const TILES_PER_ROW = 10
const TILES_PER_COL = 9
const SCREEN_HEIGHT = 144
const SCREEN_WIDTH = 160

const MAP_TILES_GROUP = 'map_tiles'
const GRID_SQUARE_GROUP = 'grid_square'

const CANT_MOVE = 999999

enum DIRECTIONS {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

enum UNIT_TYPES {
	ANGLER_MALE,
	ANGLER_FEMALE
}
