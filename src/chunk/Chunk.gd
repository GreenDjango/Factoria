class_name Chunk
extends Node2D

var chunk_data := []
var chunk_coords := Vector2(): set = _chunk_coords_setter
var chunk_id : String
var chunk_entities := {}

const TILE_SIZE := GlobalsStatic.TILE_SIZE
const CHUNK_SIZE := GlobalsStatic.CHUNK_SIZE

@onready var ground : TileMap = $Ground
@onready var entities_node : Node2D = $Entities

func _ready():
	pass

func setup(_chunk_coords : Vector2):
	_chunk_coords_setter(_chunk_coords)
	position = Chunk.coords_to_world_position(chunk_coords)
	$Coords.text = str(chunk_coords)
	_generate_ground_grass()
	_apply_ground_checkboard()
	_generate_entities()

func _generate_ground_grass():
	var x = 0
	var y = 0
	while x < CHUNK_SIZE.x:
		while y < CHUNK_SIZE.y:
			var cell = ground.get_cell_source_id(-1, Vector2i(x, y))
			if (cell == -1):
				ground.set_cell(-1, Vector2i(x, y), 15)
			y += 1
		y = 0
		x += 1

func _apply_ground_checkboard():
	var used_cells = ground.get_used_cells_by_id(-1, 15)
	for cell in used_cells:
		if (int(cell.x) % 2 == int(cell.y) % 2):
			ground.set_cellv(cell, 16)
		else:
			ground.set_cellv(cell, 17)

func _generate_entities():
	if (chunk_id == "0:0" || chunk_id == "1:0"):
		return
	var x = 0
	var y = 0
	while x < CHUNK_SIZE.x:
		while y < CHUNK_SIZE.y:
			var entity : Entity = null
			if (randi() % 10 == 0):
				entity = Globals.entities[Globals.ENTITIES_ID.TREE].instantiate()
			elif (randi() % 10 == 0):
				entity = Globals.entities[Globals.ENTITIES_ID.ROCK].instantiate()
			if (entity):
				entities_node.add_child(entity, true)
				entity.position = Vector2(x * TILE_SIZE.x + TILE_SIZE.x/ 2, y * TILE_SIZE.x + TILE_SIZE.y / 2)
				chunk_entities[Chunk.coords_to_id(Vector2(x, y))] = entity
			y += 1
		y = 0
		x += 1

func get_entity_from_world_position(pos : Vector2) -> Entity:
	var local_pos = Vector2(pos.x - position.x, pos.y - position.y)
	var coords = Vector2(int(local_pos.x / TILE_SIZE.x), int(local_pos.y / TILE_SIZE.y))
	return chunk_entities.get(Chunk.coords_to_id(coords))

func _chunk_coords_setter(new_coords):
	chunk_coords = Vector2(int(new_coords.x), int(new_coords.y))
	chunk_id = Chunk.coords_to_id(new_coords)

static func coords_to_id(coords : Vector2) -> String:
	return str(int(coords.x)) + ":" + str(int(coords.y))

static func id_to_coords(id : String) -> Vector2:
	var arr = id.split(":")
	assert(arr.size() == 2, "Invalid ID string")
	return Vector2(int(arr[0]), int(arr[1]))

static func world_position_to_coords(pos : Vector2) -> Vector2:
	return Vector2(int(pos.x / (CHUNK_SIZE.x * TILE_SIZE.x)), int(pos.y / (CHUNK_SIZE.y * TILE_SIZE.y)))

static func coords_to_world_position(coords : Vector2) -> Vector2:
	return Vector2(coords.x * (CHUNK_SIZE.x * TILE_SIZE.x), coords.y * (CHUNK_SIZE.y * TILE_SIZE.y))
