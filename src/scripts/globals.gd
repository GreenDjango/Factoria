class_name GlobalsStatic
extends Node

const TILE_SIZE := Vector2(16, 16)
const CHUNK_SIZE := Vector2(16, 16)
const RENDER_DISTANCE := Vector2(3, 3)

const ACTION_TICK_DURATION : int = 500

const entities := {
	0: preload("res://src/entities/tree/Tree.tscn"),
	1: preload("res://src/entities/rock/Rock.tscn"),
}

enum ENTITIES_ID { 
	TREE = 0,
	ROCK = 1,
}

var chunks := {}

func _ready():
	pass

