extends TextureProgress


# Declare member variables here. Examples:
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	value = max_value


func _process(delta):
	if(active):
		if(value > min_value):
			value = value-delta
		else:
			stop()

func set_max_value(max_val):
	max_value = max_val
	value = max_value
	
func stop():
	active = false
	value = max_value

func start():
	active = true
	value = max_value
