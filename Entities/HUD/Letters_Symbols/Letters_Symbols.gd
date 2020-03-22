extends CanvasLayer

# bring in our global constants
onready var constants = get_node("/root/Game_Constants")

# bring in our game config vars
onready var game_cfg_vars = get_node("/root/Game_Config")

# local constants
const DIA_TILE_WIDTH = 8
const DIA_TILE_HEIGHT = 8
const DIALOGUE_HEIGHT = 48
const DIALOGUE_WIDTH = 160

onready var tileMap = get_node("TileMap")
onready var arrowDownSprite = get_node("Arrow_Down_Sprite")
onready var arrowRightSprite = get_node("Arrow_Right_Sprite")
onready var dialogueSound = get_node("Dialogue_Sound")

var tileSet
var currentTime = 0

func stopTimer(timer):
	timer.stop()
	remove_child(timer)
	
func timeoutTimer(timer): # trigger the timeout early
	timer.start(.0001)
	

func setTextCell(letterSymbol, pos, timer = null, sound = true):
	tileMap.set_cellv(pos, tileSet.find_tile_by_name("LS_Code_" + String(letterSymbol.ord_at(0))))
	
	# if there is a timer, stop it
	if (timer):
		stopTimer(timer)
	
	# play the dialogue sound
	if (sound):
		dialogueSound.play()
	
func letters_symbols_init():
	tileSet = tileMap.get_tileset()
	
	# position arrow down sprite
	arrowDownSprite.position = Vector2(constants.SCREEN_WIDTH - (DIA_TILE_WIDTH*3), constants.SCREEN_HEIGHT - (DIA_TILE_HEIGHT*2))
	
func startArrowDownTimer():
	var downArrowTimer = Timer.new()
	downArrowTimer.wait_time = currentTime
	downArrowTimer.connect("timeout", self, "showArrowDown", [downArrowTimer])
	add_child(downArrowTimer)
	downArrowTimer.start()
	
func showArrowDown(downArrowTimer):
	arrowDownSprite.visible = true
	stopTimer(downArrowTimer) # stop and remove timer
	
func hideArrowDown():
	arrowDownSprite.visible = false
	
func clearText():
	tileMap.clear()
	hideArrowDown()
	currentTime = 0
	
func clear_text_non_dialogue():
	tileMap.clear()
	
func generateLetterSymbol(letterSymbol, pos):
	# generate text, using a timer
	var textTimer = Timer.new()
	textTimer.wait_time = currentTime + game_cfg_vars.messageSpeed
	currentTime = currentTime + game_cfg_vars.messageSpeed
	
	textTimer.connect("timeout", self, "setTextCell", [letterSymbol, pos, textTimer])
	add_child(textTimer)
	
	textTimer.start()

func print_immediately(text, start_pos):
	for letter in text:
		setTextCell(letter, start_pos, null, false)
		start_pos.x += 1
	pass
	
func print_special_immediately(special_symbol, pos):
	match(special_symbol):
		constants.SPECIAL_SYMBOLS.RIGHT_ARROW:
			print('TRYEW')
			arrowRightSprite.position = pos
			arrowRightSprite.visible = true
			

# Called when the node enters the scene tree for the first time.
func _ready():
	letters_symbols_init()
