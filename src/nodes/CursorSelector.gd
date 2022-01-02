extends Node2D

onready var zone_highlight := $ZoneHighlight
onready var select_tl := $SelectTL
onready var select_tr := $SelectTR
onready var select_br := $SelectBR
onready var select_bl := $SelectBL
onready var action_icon := $ActionIcon
onready var action_icon_under := $ActionIcon/ActionIconUnder

var hover_color := ColorN("white", 0.3)
var hover_warning_color := ColorN("red", 0.3)

var selector_size := Vector2(1, 1)
var chunks := Globals.chunks
var entity_selected : Entity = null
var action_step_need : int = 0
var action_step_remaining : int = 0
var action_current_step : float = .0
var is_doing_action := false

func _ready():
	action_icon.visible = false

func _process(delta : float):
	_refresh_action_progress(delta)
	
func _input(event : InputEvent):
	if event.is_action_pressed("interact"):
		_set_current_action(true)
	if event.is_action_released("interact"):
		_set_current_action(false)
	if event.is_action_pressed("cursor_switch_up"):
		_set_cursor_selector_size(selector_size + Vector2(1, 1))
	if event.is_action_pressed("cursor_switch_down") && selector_size.x > 1:
		_set_cursor_selector_size(selector_size - Vector2(1, 1))
	if event is InputEventMouse && not is_doing_action:
		_refresh_position()
		_refresh_status()

func _refresh_action_progress(delta : float):
	if not is_doing_action:
		return
	action_current_step += delta * 1000
	while action_current_step >= Globals.ACTION_TICK_DURATION:
		action_current_step -= Globals.ACTION_TICK_DURATION
		action_step_remaining += 1
	if action_step_remaining >= action_step_need:
		_set_current_action(false)
	var action_progress = (action_step_remaining + 1) / float(action_step_need + 1)
	action_icon.material.set_shader_param("fill_ratio", action_progress)
	zone_highlight.material.set_shader_param("fill_ratio", action_progress)

func _refresh_position():
	# var world_pos = get_viewport_transform().affine_inverse().xform(get_viewport().get_mouse_position())
	var world_pos = get_viewport_transform().affine_inverse().origin + get_viewport().get_mouse_position()
	var is_x_even = 0 if int(selector_size.x) % 2 else 8
	var is_y_even = 0 if int(selector_size.y) % 2 else 8
	world_pos.x = Utils.round_step(world_pos.x, 16, is_x_even) - 8
	world_pos.y = Utils.round_step(world_pos.y, 16, is_y_even) - 8
	position = world_pos

func _refresh_status():
	var entity : Entity = null
	var chunk_coords = Chunk.world_position_to_coords(position)
	var chunk_id = Chunk.coords_to_id(chunk_coords)
	if chunks.has(chunk_id):
		var chunk : Chunk = chunks[chunk_id]
		entity = chunk.get_entity_from_world_position(position)
	if entity_selected == entity:
		return
	entity_selected = entity
	if entity:
#		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		_set_action_icon(true, entity.action_type)
		modulate = Color.white
	else:
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_set_action_icon(false)
		modulate = Color(1, 1, 1, 0.4)

func _set_action_icon(is_visible : bool, action_type : int = 0):
	action_icon.visible = is_visible
	action_icon.frame = action_type
	action_icon_under.frame = action_type
	action_icon.material.set_shader_param("sprite_frame", action_type)
	action_icon.material.set_shader_param("fill_ratio", 0)
	zone_highlight.material.set_shader_param("fill_ratio", 1)

func _set_current_action(active : bool):
	action_step_need = 0
	action_step_remaining = 0
	action_current_step = .0
	if active && entity_selected:
		action_step_need = entity_selected.action_need_tick
		is_doing_action = true
	else:
		is_doing_action = false

func _set_cursor_selector_size(size : Vector2):
	selector_size = size
	var new_size = selector_size * 8
	select_tl.position = Vector2(-new_size.x, -new_size.y)
	select_tr.position = Vector2(new_size.x, -new_size.y)
	select_br.position = Vector2(new_size.x, new_size.y)
	select_bl.position = Vector2(-new_size.x, new_size.y)
	zone_highlight.scale = selector_size
	zone_highlight.self_modulate = hover_warning_color
