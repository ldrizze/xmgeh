extends Node

class_name EnemySpawner

@export var enemies: Array[EnemySpawnerConfig] = []
@export var wave_time: float = 3.0
@export var character_reference: CharacterBase
@export var enabled: bool = false
@export var top_left_spawn: Marker2D
@export var bottom_right_spawn: Marker2D

func _ready():
	character_reference.connect("on_dead", _on_player_dead)

func _process(delta):
	if !enabled: return

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
		var spawn_position = Vector2(
				randf_range(-1.0, 1.0), 
				randf_range(-1.0, 1.0)
				).normalized() * max(100.0, e.distance) + character_reference.global_position
				
		if spawn_position.x < top_left_spawn.position.x: spawn_position.x = top_left_spawn.position.x
		if spawn_position.y < top_left_spawn.position.y: spawn_position.y = top_left_spawn.position.y
		
		if spawn_position.x > bottom_right_spawn.position.x: spawn_position.x = bottom_right_spawn.position.x
		if spawn_position.y > bottom_right_spawn.position.y: spawn_position.y = bottom_right_spawn.position.y
		
		instance.position = spawn_position
		instance.start(character_reference)

func _on_player_dead():
	enabled = true
