extends Panel

var max_levels = 20
var current_level = 0
var colorOrder = [];
var pressedOrder = []

var has_won = false
var has_lost = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	colorOrder = [];
	for m in max_levels:
		colorOrder.append(randi()%4)
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
			0:
				yield($Red_Button.glow(),"completed")
			1:
				yield($Yellow_Button.glow(),"completed")
			2:
				yield($Blue_Button.glow(),"completed")
			3:
				yield($Green_Button.glow(),"completed")
		print(colorOrder[m])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Red_Button_pressed():
	pressedOrder.append(0)
	_check()

func _on_Yellow_Button_pressed():
	pressedOrder.append(1)
	_check()
	
func _on_Blue_Button_pressed():
	pressedOrder.append(2)
	_check()

func _on_Green_Button_pressed():
	pressedOrder.append(3)
	_check()

func _check():
	print("PressedOrder:",pressedOrder)
	var current_index = pressedOrder.size()-1
	has_lost = pressedOrder[current_index] != colorOrder[current_index]
	if has_lost:
		print("You Loose, Looser :c")
	if !has_lost && pressedOrder.size()==current_level:
		_start_level()
