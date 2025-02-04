extends Node

class_name SkillBase

enum ESkillType {
	BULLET,
	POWER
}

@export var destroy_at_distance: float = 500.0
@export var destroy_at_hit: bool = true
@export var destroy_after_s: float = 1000
@export var character_base_instance: CharacterBase
@export var skill_type: ESkillType = ESkillType.BULLET
@export var skill_level: int = 1

@export_category("Bullet settings")
@export var bullet_resource: PackedScene
@export var spawn_interval_s: float = 1.0
@export var bullet_velocity: float = 100
@export var shoot_at_spawn: bool = false

@onready var _elapsed_bullet_time: float = 0.0 if !shoot_at_spawn else 99.0
var _player_dead: bool = false

func _ready():
	character_base_instance.connect("on_dead", _on_player_dead)

func _process(delta):
	if _player_dead: return

	if !character_base_instance: return

	if (skill_type == ESkillType.BULLET):
		_elapsed_bullet_time += delta
		
		if _elapsed_bullet_time > spawn_interval_s:
			_elapsed_bullet_time = 0
			_spawn_bullet()

func _spawn_bullet():
	var bullet_instance = _create_bullet_instance()
	$Bullets.add_child(bullet_instance)
	
	bullet_instance.shoot(
		Vector2.RIGHT.rotated(
			character_base_instance.get_aim_angle()
			).normalized() * bullet_velocity
	)
	
	if character_base_instance.level >= 2:
		var second_bullet = _create_bullet_instance()
		$Bullets.add_child(second_bullet)

		second_bullet.shoot(
			Vector2.RIGHT.rotated(
			character_base_instance.get_aim_angle() + deg_to_rad(15)
			).normalized() * bullet_velocity
		)

func _on_player_dead():
	_player_dead = true

func _create_bullet_instance() -> BulletBase:
	var bullet_instance = bullet_resource.instantiate() as BulletBase
	bullet_instance._destroy_after_distance = destroy_at_distance
	bullet_instance._destroy_after_time = destroy_after_s
	bullet_instance._destroy_on_hit = true
	bullet_instance.global_position = character_base_instance.get_aim_position()
	bullet_instance.global_position = character_base_instance.get_aim_position()
	return bullet_instance
