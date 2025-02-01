extends Node2D

class_name BulletBase

@export var damage: float = 50.0

var _shot_direction: Vector2
var _started: bool = false
var _destroy_on_hit: bool = true
var _destroy_after_time: float = -1
var _destroy_after_distance: float = -1
var _elapsed_time_alive: float = 0
var _initial_position: Vector2
var _colliding: bool = false

func _ready():
	hide()
	_initial_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _started:
		position += delta * _shot_direction
		_elapsed_time_alive += delta
		
		if (
			(_destroy_after_time != -1 and _elapsed_time_alive > _destroy_after_time) or
			(
				_destroy_after_distance != -1 and _initial_position.distance_to(global_position) > _destroy_after_distance
			) or
			(_destroy_on_hit and _colliding)
			):
			queue_free()

func shoot(direction: Vector2):
	_shot_direction = direction
	_started = true
	show()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	_colliding = true

func _on_area_2d_body_entered(body):
	_colliding = true
	
	if body.has_method("get_collision_layer") and body.get_collision_layer() == 2:
		(body as EnemyBase).take_damage(damage)

func _on_area_2d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	_colliding = true

func _on_area_2d_area_entered(area):
	_colliding = true
