extends Panel

var max_levels = 20
var current_level = 0

const colors = ["Red","Yellow","Blue","Green"];

var colorOrder = [];
var pressedOrder = []

var has_won = false
var has_lost = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	colorOrder = [];
	for m in max_levels:
		colorOrder.append(colors[randi()%4])
	_start_level()
	_play_level()
	#get_node("TextureButton").connect("button_down",self,"_on_TextureButton_button_down");
	
func _play_level():
	if has_lost:
		print("You Loose, Looser :c")
	if !has_lost && pressedOrder.size()==current_level:
		_start_level()

func _start_level():
	current_level += 1
	pressedOrder = []
	_show_level(current_level)
	print("Color Order:",colorOrder)

func _show_level(level):
	for m in level:
		match colorOrder[m]:
			"Red":
				yield($Red_Button.glow(),"completed")
			"Yellow":
				yield($Yellow_Button.glow(),"completed")
			"Blue":
				yield($Blue_Button.glow(),"completed")
			"Green":
				yield($Green_Button.glow(),"completed")
		print(colorOrder[m])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _check():
	print("PressedOrder:",pressedOrder)
	var current_index = pressedOrder.size()-1
	has_lost = pressedOrder[current_index] != colorOrder[current_index]
	if has_lost:
		print("You Loose, Looser :c")
	if !has_lost && pressedOrder.size()==current_level:
		yield(get_tree().create_timer(2), "timeout")
		_start_level()

func _on_button_hit(id):
	pressedOrder.append(id)
	_check()
