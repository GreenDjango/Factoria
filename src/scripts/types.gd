class_name Types
extends RefCounted

enum ACTION_TYPES {
	AXE = 0, WATERCAN, SWORD, PICKAXE, SHOVEL, ROD, ROD_ALT, PLAYER, PLANT,
	PLANT_ALT, STOPWATCH, SANDTIMER, BASKET, HAND_BIG_OPEN, HAND_BIG_CLOSED,
	HAND_OPEN, HAND_CLOSED
}

enum Direction { RIGHT = 1, DOWN = 2, LEFT = 4, UP = 8 }

const NEIGHBORS := {
	Direction.RIGHT: Vector2.RIGHT,
	Direction.DOWN: Vector2.DOWN,
	Direction.LEFT: Vector2.LEFT,
	Direction.UP: Vector2.UP
}

const POWER_MOVERS := "power_movers"
const POWER_RECEIVERS := "power_receivers"
const POWER_SOURCES := "power_sources"
const GUI_ENTITIES := "gui_entities"
const WORKERS := "workers"
