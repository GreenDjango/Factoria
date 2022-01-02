extends Entity

func _ready():
	action_type = Types.ACTION_TYPES.PICKAXE
	action_need_tick = 10
	# $Particles2D.preprocess = rand_range(0, 100)
