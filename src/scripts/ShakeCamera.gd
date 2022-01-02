extends Camera2D
class_name ShakeCamera

export(float, 0.01, 20.0) var vibration_ampl := 1.0
export var smoothed := false
export(float, 1, 10.0) var smooth_speed := 1
var remaining_time_in_s := .0
var smooth_offset_x := .0
var smooth_offset_y := .0

func _ready():
	pass

func _process(delta : float):
	if remaining_time_in_s > 0:
		remaining_time_in_s -= delta
		if remaining_time_in_s <= 0:
			remaining_time_in_s = 0
			offset = Vector2.ZERO
		if smoothed:
			if Utils.compare_floats(smooth_offset_x, offset.x, 0.01):
				smooth_offset_x = rand_range(-1, 1) * vibration_ampl
			if Utils.compare_floats(smooth_offset_y, offset.y, 0.01):
				smooth_offset_y = rand_range(-1, 1) * vibration_ampl
			offset.x = lerp(offset.x, smooth_offset_x, min(1, delta * 10 * smooth_speed))
			offset.y = lerp(offset.y, smooth_offset_y, min(1, delta * 10 * smooth_speed))
		else:
			offset.x = rand_range(-1, 1) * vibration_ampl
			offset.y = rand_range(-1, 1) * vibration_ampl

func shake(duration_in_ms : int):
	remaining_time_in_s = duration_in_ms / 1000.0
