extends Control

class_name GameHUD

func _process(delta):
	pass

func set_xp(xp: float):
	$XP.value = xp

func set_level(level: int):
	$Level.text = str(level)

func set_game_time(minutes: int, seconds: int):
	$Time/Minutes.text = "%02d" % [minutes]
	$Time/Seconds.text = "%02d" % [seconds]
