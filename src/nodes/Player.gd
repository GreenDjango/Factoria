class_name Player
extends KinematicBody2D

var velocity := Vector2.ZERO
const speed_max := 70.0
var acceleration := 0.1
const acceleration_step := 0.04
const friction := 6.0

onready var shape_sprite := $Shape
onready var hair_sprite := $Hair
onready var hand_sprite := $Hand

func _ready():
	_play_animation("idle")

func _physics_process(_delta : float):
	var input := Vector2.ZERO
	if Input.is_action_pressed("player_right"):
		input.x += 1
	if Input.is_action_pressed("player_left"):
		input.x -= 1
	if Input.is_action_pressed("player_down"):
		input.y += 1
	if Input.is_action_pressed("player_up"):
		input.y -= 1
	_move_player(input.normalized())

func _move_player(input: Vector2):
	if input != Vector2.ZERO:
		if acceleration < 1:
			acceleration += acceleration_step
		_play_animation("walk")
	else:
		if acceleration > 0.1:
			acceleration -= acceleration_step*2
		_play_animation("idle")

	if input.x != 0:
		velocity.x = input.x * speed_max * acceleration
		if velocity.x > 0:
			_flip_sprite(false)
		elif velocity.x < 0:
			_flip_sprite(true)
	else:
		velocity.x = move_toward(velocity.x, 0, friction)

	if input.y != 0:
		velocity.y = input.y * speed_max * acceleration
	else:
		velocity.y = move_toward(velocity.y, 0, friction)

	# warning-ignore:return_value_discarded
	move_and_slide(velocity)

func _play_animation(name : String):
	shape_sprite.play(name)
	hair_sprite.play(name)
	hand_sprite.play(name)

func _flip_sprite(is_flip : bool):
	shape_sprite.flip_h = is_flip
	hair_sprite.flip_h = is_flip
	hand_sprite.flip_h = is_flip
