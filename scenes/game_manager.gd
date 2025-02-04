extends Node

@export var hud: GameHUD
@export var character: CharacterBase

class GameTime:
	var seconds: int
	var minutes: int
	
	func _init():
		self.seconds = 0
		self.minutes = 0
		
	func inc_minute():
		self.seconds = 0
		self.minutes += 1
		
	func inc_seconds():
		self.seconds += 1
		
		if self.seconds == 60:
			self.inc_minute()

var _elapsed_game_time: float
var _game_time: GameTime

func _ready():
	_game_time = GameTime.new()
	character.connect("on_level_up", _on_character_level_up)
	hud.set_level(character.level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_elapsed_game_time += delta
	
	if _elapsed_game_time >= 1.0:
		_game_time.inc_seconds()
		_elapsed_game_time = 0.0
		hud.set_game_time(_game_time.minutes, _game_time.seconds)

func _on_character_level_up(level: int):
	hud.set_level(level)
