extends Panel

var max_levels = 20
var current_level = 0

const colors = ["Red","Yellow","Blue","Green"];

var colorOrder = [];
var pressedOrder = [];

var has_won = false;
var has_lost = false;

export var winTone : AudioStream;
export var loseTone : AudioStream;

var feedbackPlayer = AudioStreamPlayer.new();

var tonesBus = AudioServer.get_bus_index("Tones");
var feedbackBus = AudioServer.get_bus_index("Tones");

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(feedbackPlayer)
	colorOrder = [];
	_create_game();
	#get_node("TextureButton").connect("button_down",self,"_on_TextureButton_button_down");

func _create_game():
	colorOrder = [];
	randomize();
	for m in max_levels:
		colorOrder.append(colors[randi()%4])
	_start_level(1)

func _start_level(level):
	pressedOrder = []
	
	current_level = level
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

func _check():
	print("PressedOrder:",pressedOrder)
	var current_index = pressedOrder.size()-1
	has_lost = pressedOrder[current_index] != colorOrder[current_index]
	if has_lost:
		_lose()
		print("You Loose, Looser :c")
	if !has_lost && pressedOrder.size()==current_level:
		_win()
		
func _lose():
	yield(get_tree().create_timer(0.5), "timeout")
	feedbackPlayer.stream = loseTone;
	feedbackPlayer.play()
	$Red_Button.set_wrong(true)
	$Yellow_Button.set_wrong(true)
	$Blue_Button.set_wrong(true)
	$Green_Button.set_wrong(true)
	yield($Green_Button.set_wrong(true),"completed")
	yield(feedbackPlayer,"finished")
	$Red_Button.set_wrong(false)
	$Yellow_Button.set_wrong(false)
	$Blue_Button.set_wrong(false)
	$Green_Button.set_wrong(false)
	yield(get_tree().create_timer(0.5), "timeout")
	_create_game()
	
func _win():
	yield(get_tree().create_timer(0.75), "timeout")
	$Red_Button.set_glow(true)
	$Yellow_Button.set_glow(true)
	$Blue_Button.set_glow(true)
	$Green_Button.set_glow(true)
	feedbackPlayer.stream = winTone;
	feedbackPlayer.play()
	yield(feedbackPlayer,"finished")
	$Red_Button.set_glow(false)
	$Yellow_Button.set_glow(false)
	$Blue_Button.set_glow(false)
	$Green_Button.set_glow(false)
	yield(get_tree().create_timer(0.5), "timeout")
	_start_level(current_level + 1)

func _on_button_hit(id):
	pressedOrder.append(id)
	_check()
