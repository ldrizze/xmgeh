extends CharacterBody2D

class_name CharacterBase

signal on_dead

@export_category("Movement settings")
@export var movement_velocity: float = 100
@export var hp: float = 100.0

var _dead: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _dead: return
	
	# process weapon angle
	var mouse_pos = get_centered_mouse_position()
	$WeaponPivot.look_at(mouse_pos + global_position)
	
	# process movement
	var movement_direction = Vector2.ZERO
	if Input.is_action_pressed("move_down"):
		movement_direction.y += 1
	elif Input.is_action_pressed("move_up"):
		movement_direction.y -= 1
	
	if Input.is_action_pressed("move_right"):
		movement_direction.x += 1
	elif Input.is_action_pressed("move_left"):
		movement_direction.x -= 1
	
	velocity = movement_direction.normalized() * movement_velocity
	move_and_slide()

func get_centered_mouse_position() -> Vector2:
	var mouse_pos = get_viewport().get_mouse_position()
	return (mouse_pos - Vector2(1280/2.0, 720/2.0))

func get_aim_angle() -> float:
	return $WeaponPivot.rotation
	
func get_aim_position() -> Vector2:
	return $WeaponPivot/Aim.global_position

func take_damage(damage: float):
	if _dead: return
	$DamageAnimation.play("damage")
	hp -= damage
	
	if hp <= 0:
		_dead = true
		on_dead.emit()
		$DamageAnimation.play("dead")
