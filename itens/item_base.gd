extends Node2D

class_name ItemBase

enum EItemType {
	POTION,
	MAGNET
}

@export var item_type: EItemType = EItemType.POTION
@export var travel_time: float = 0.7777
@export var character_reference: CharacterBase
@export var trave_smooth_curve: Curve

var _traveling: bool = false
var _travel_elapsed_time: float = 0
var _original_position: Vector2 = Vector2.ZERO

func _process(delta):
	if _traveling:
		_travel_elapsed_time += delta
		position = _original_position.lerp(
			character_reference.global_position,
			trave_smooth_curve.sample_baked(_travel_elapsed_time/travel_time)
		)

func _on_collect_area_body_entered(body):
	if body.has_method("get_collision_layer_value") and body.get_collision_layer_value(1):
		_traveling = true
		_original_position = position

func _on_use_area_body_entered(body):
	character_reference.use_item(self)
	queue_free()
