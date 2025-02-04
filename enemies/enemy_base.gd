extends CharacterBody2D

class_name EnemyBase

@export var player_damage_interval_s: float = 1
@export var enemy_velocity: float = 100
@export var hp: float = 100
@export var contact_damage: float = 10.0
@export var xp: float = 10.0

var _character_reference: CharacterBase
var _started: bool = false
var _in_damage: bool = false
var _damage_interval_elapsed_time: float = 0.0
var _player_dead: bool = false
var _dead: bool = false
@onready var _initial_velocity: float = enemy_velocity

func _physics_process(delta):
	if !_started or hp <= 0 or _player_dead: return
	
	velocity = (
		(_character_reference.global_position - global_position).normalized() *
		enemy_velocity * delta * 100
		)
	move_and_slide()

	if get_slide_collision_count() > 0:
		for i in range(get_slide_collision_count()):
			var body = get_slide_collision(i).get_collider()
			
			# DETECT DAMAGE
			if (
				body.has_method("get_collision_layer") and
				body.get_collision_layer() == 1 and !_in_damage
				):
				enemy_velocity = enemy_velocity * 0.2
				$Timer.start()
				_in_damage = true
				_damage_interval_elapsed_time = 99.0
			
			# DAMAGE
			if _in_damage:
				_damage_interval_elapsed_time += delta
				
				if _damage_interval_elapsed_time > player_damage_interval_s:
					_character_reference.take_damage(contact_damage)
					_damage_interval_elapsed_time = 0.0

func start(reference: CharacterBase):
	if !reference: return
	_character_reference = reference
	_started = true
	_character_reference.connect("on_dead", _on_player_dead)

func take_damage(damage: float, _direction: Vector2 = Vector2.ZERO):
	if hp <= 0: return

	hp -= damage
	if hp <= 0:
		_dead = true
		$DamageShaderPlayer.play("death")
		_character_reference.gain_xp(xp)
		$CollisionShape2D.set_deferred("disabled", true)
	else: $DamageShaderPlayer.play("damage")

func _on_damage_shader_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()

func _on_timer_timeout():
	enemy_velocity = _initial_velocity
	_in_damage = false

func _on_player_dead():
	_player_dead = true
