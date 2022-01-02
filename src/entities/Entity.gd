class_name Entity
extends Node2D

const OUTLINE_SIZE := 3.0
# const OutlineMaterial := preload("res://Shared/outline_material.tres")

var action_type : int = Types.ACTION_TYPES.HAND_OPEN
var action_need_tick : int = 1

func _ready():
	pass

#func toggle_outline(enabled: bool) -> void:
#	for sprite in _sprites:
#		if sprite.material:
#			sprite.material.set_shader_param("line_thickness", OUTLINE_SIZE if enabled else 0.0)

#func _find_sprite_children_of(parent: Node) -> void:
#	var outline_material := OutlineMaterial.duplicate()
#	for child in parent.get_children():
#		if child is Sprite and not child.material:
#			_sprites.push_back(child)
#			child.material = outline_material
#		_find_sprite_children_of(child)
