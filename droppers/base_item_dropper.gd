extends StaticBody2D

## Drop chance from 0 (0%) to 1 (100%)
@export var drop_chance: float = 0.17

var _hp_item = preload("res://itens/item_base.tscn") as PackedScene

func drop_item():
	var instance = _hp_item.instantiate()
	instance.position = position
	get_node("/root").add_child(instance)
