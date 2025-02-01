extends Node

class_name EnemySpawner

@export var enemies: Array[EnemySpawnerConfig] = []
@export var wave_time: float = 3.0
@export var character_reference: CharacterBase

var _player_dead: bool = false

func _ready():
	character_reference.connect("on_dead", _on_player_dead)

func _process(delta):
	if _player_dead: return

	for enemy in enemies:
		enemy._time_elapsed += delta
		
		if enemy._time_elapsed > wave_time:
			enemy._time_elapsed = 0
			enemy._wave_number += 1
			
			for s in range(enemy.base_quantity):
				_spawn_enemy(enemy)

func _spawn_enemy(e: EnemySpawnerConfig):
	if e:
		var instance = e.enemy.instantiate() as EnemyBase
		$Enemies.add_child(instance)
		instance.position = (
			character_reference.global_position +
			Vector2(-randf_range(100, e.distance), randf_range(100, e.distance))
			)
		instance.start(character_reference)

func _on_player_dead():
	_player_dead = true
