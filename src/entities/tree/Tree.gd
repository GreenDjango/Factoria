extends Entity

func _ready():
	action_type = Types.ACTION_TYPES.AXE
	action_need_tick = 4
	# $Particles2D.preprocess = rand_range(0, 100)
