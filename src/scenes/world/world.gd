extends Node2D

@export var chunk_scene : PackedScene
@export var player : Player
@export var chunks_parent : Node2D

var current_chunk_coords := Vector2()
var chunks := Globals.chunks

const CHUNK_SIZE := GlobalsStatic.CHUNK_SIZE
const RENDER_DISTANCE := GlobalsStatic.RENDER_DISTANCE

func _ready():
	assert(player, "Player is null")
	assert(chunks_parent, "Chunk parent is null")

func _process(_delta: float):
	var player_chunk_coords := Chunk.world_position_to_coords(player.position)
	if (current_chunk_coords != player_chunk_coords):
		_load_chunks(player_chunk_coords)
		current_chunk_coords = player_chunk_coords

func _load_chunks(from_coords : Vector2):
	var x = RENDER_DISTANCE.x - int(RENDER_DISTANCE.x / 2) - 1
	var y = RENDER_DISTANCE.y - int(RENDER_DISTANCE.y / 2) - 1
	var min_x = -x
	var min_y = -y
	while x >= min_x:
		while y >= min_y:
			var chunk_coords := Vector2(from_coords.x + x , from_coords.y + y)
			y -= 1
			if (chunk_coords.x < 0 || chunk_coords.y < 0):
				continue
			var chunk_id := Chunk.coords_to_id(chunk_coords)
			if !chunks.has(chunk_id):
				var new_chunk : Chunk = chunk_scene.instantiate()
				chunks_parent.add_child(new_chunk, true)
				chunks[chunk_id] = new_chunk
				new_chunk.setup(chunk_coords)
		y = -min_y
		x -= 1
