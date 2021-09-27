extends Node

var max_levels = 20
var current_level = 0

const colors = ["Red","Yellow","Blue","Green"];
const notes_FrBg = {"Do":261.63,"Re":293.665,"Mi":329.628,"Fa":349.228,"Sol":391.995,"La":440,"Si":493.883,"Do4":523.25}

var colorOrder = [];
var notesOrder = []
var pressedOrder = [];

var notes=[0,0,0,0,0,0,0,0]
var notes_highest=[0,0,0,0,0,0,0,0]

var has_won = false;
var is_listening = false;
var has_lost = false;

export var winTone : AudioStream;
export var loseTone : AudioStream;

var feedbackPlayer = AudioStreamPlayer.new();

var RedButton;
var YellowButton;
var BlueButton;
var GreenButton;
var NoteLabel;

var spectrum

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(feedbackPlayer);
	RedButton = find_node("RedButton");
	YellowButton = find_node("YellowButton");
	BlueButton = find_node("BlueButton");
	GreenButton = find_node("GreenButton")
	NoteLabel = find_node("Nota");
	spectrum = AudioServer.get_bus_effect_instance(3,0)
	_create_game();
	#get_node("TextureButton").connect("button_down",self,"_on_TextureButton_button_down");
	
func _create_game():
	colorOrder = [];
	NoteLabel.text="";
	randomize();
	for m in max_levels:
		colorOrder.append(colors[randi()%4])
	_start_level(1)

func _start_level(level):
	pressedOrder = []
	notesOrder = []
	current_level = level
	
	for m in current_level:
		notesOrder.append(notes_FrBg.keys()[randi()%8])
	
	_show_level(current_level)
	$Timer.start(3.0)
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

func _show_note(note):
	NoteLabel.text = note
	yield(get_tree().create_timer(0.5),"timeout");
	NoteLabel.text=""
	

func _check():
	$Timer.stop()
	print("PressedOrder:",pressedOrder)
	var current_index = pressedOrder.size()-1
	has_lost = pressedOrder[current_index] != colorOrder[current_index]
	if has_lost:
		_lose()
		print("You Loose, Looser :c")
		
	elif !has_lost && !pressedOrder.size()==current_level :
		yield(_show_note(notesOrder[pressedOrder.size()-1]),"completed")
		is_listening = true
		_disable_all(true)
		yield(get_tree().create_timer(3.0),"timeout")
		_check_note()
		_disable_all(false)
		is_listening = false
		$Timer.start(3.0)
		
	if !has_lost && pressedOrder.size()==current_level:
		_win()

func _check_note():
	if notes_FrBg.keys()[notes_highest.find(notes_highest.max())] == notesOrder[pressedOrder.size()-1]:
		pass
	else:
		_lose()

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


func _on_Timer_timeout():
	_lose()

func _process(delta):
	if is_listening:
		notes = [_in_tune_val("Do"),_in_tune_val("Re"),_in_tune_val("Mi"),_in_tune_val("Fa"),_in_tune_val("Sol"),_in_tune_val("La"),_in_tune_val("Si"),_in_tune_val("Do4")]
		
		for note in notes:
			notes[notes.find(note)] = null if stepify(note,0.0001) == 0.000 else stepify(note,0.0001)
			if notes[notes.find(note)] != null :
				notes_highest[notes.find(note)] = notes_highest[notes.find(note)] if notes_highest[notes.find(note)] > notes[notes.find(note)] else notes[notes.find(note)]

func _in_tune_val(var note):
	return spectrum.get_magnitude_for_frequency_range(floor(notes_FrBg[note]),ceil(notes_FrBg[note])).length();
