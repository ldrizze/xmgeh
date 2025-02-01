class_name EnemySpawnerConfig extends Resource

@export var enemy: PackedScene
@export var distance: float = 1000.0
@export var base_quantity: int = 10

var _time_elapsed: float = 99.0
var _wave_number: int = 0
