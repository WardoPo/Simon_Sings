extends Node

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

var RedButton;
var YellowButton;
var BlueButton;
var GreenButton;

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(feedbackPlayer);
	RedButton = find_node("RedButton");
	YellowButton = find_node("YellowButton");
	BlueButton = find_node("BlueButton");
	GreenButton = find_node("GreenButton")
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
	_disable_all(true)
	for m in level:
		match colorOrder[m]:
			"Red":
				yield(RedButton.glow(),"completed")
			"Yellow":
				yield(YellowButton.glow(),"completed")
			"Blue":
				yield(BlueButton.glow(),"completed")
			"Green":
				yield(GreenButton.glow(),"completed")
	_disable_all(false)

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
	_disable_all(true)
	yield(get_tree().create_timer(0.5), "timeout")
	feedbackPlayer.stream = loseTone;
	feedbackPlayer.play()
	yield(_set_wrong_all(true),"completed")
	if(feedbackPlayer.playing):
		yield(feedbackPlayer,"finished")
	yield(_set_wrong_all(false),"completed")
	_create_game()

func _win():
	_disable_all(true)
	yield(get_tree().create_timer(0.75), "timeout")
	_set_glow_all(true)
	feedbackPlayer.stream = winTone;
	feedbackPlayer.play()
	yield(feedbackPlayer,"finished")
	_set_glow_all(false)
	yield(get_tree().create_timer(0.5), "timeout")
	_start_level(current_level + 1)

func _disable_all(disabled):
	RedButton.disabled = disabled
	YellowButton.disabled = disabled
	BlueButton.disabled = disabled
	GreenButton.disabled = disabled
	
func _set_glow_all(enable):
	RedButton.set_glow(enable)
	YellowButton.set_glow(enable)
	BlueButton.set_glow(enable)
	GreenButton.set_glow(enable)

func _set_wrong_all(forward):
	RedButton.set_wrong(forward)
	YellowButton.set_wrong(forward)
	BlueButton.set_wrong(forward)
	yield(GreenButton.set_wrong(forward),"completed")

func _on_button_hit(id):
	pressedOrder.append(id)
	_check()
