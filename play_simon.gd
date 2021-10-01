extends Node

export var max_levels = 20
export var countdownTime : float
var current_level = 0

const colors = ["Red","Yellow","Blue","Green"];
const notes_FrBg = {"Do":261.63,"Re":293.665,"Mi":329.628,"Fa":349.228,"Sol":391.995,"La":440,"Si":493.883}

var colorOrder = [];
var notesOrder = []
var pressedOrder = [];

var notes=[0,0,0,0,0,0,0]
var notes_highest=[0,0,0,0,0,0,0]
var notes_sampled=[0,0,0,0,0,0,0]

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

func _process(delta):
	if is_listening:
		notes = [_in_tune_val("Do"),_in_tune_val("Re"),_in_tune_val("Mi"),_in_tune_val("Fa"),_in_tune_val("Sol"),_in_tune_val("La"),_in_tune_val("Si")]
		for note in notes:
			var index = notes.find(note)
			notes[index] = null if stepify(note,0.001) == 0.000 else stepify(note,0.001)
			if notes[index] != null :
				notes_highest[index] = notes_highest[index] if notes_highest[index] > notes[index] else notes[index]
	
func _create_game():
	colorOrder = [];
	NoteLabel.text="";
	randomize();
	for m in max_levels:
		colorOrder.append(colors[randi()%4])
	print("Color Order:",colorOrder)
	_start_level(1)

func _start_level(level):
	pressedOrder = []
	notesOrder = []
	current_level = level
	
	for m in current_level:
		notesOrder.append(notes_FrBg.keys()[randi()%7])
	
	_show_level(current_level)
	$Timer.start(countdownTime)

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

#func _show_note(note):
#	NoteLabel.text = note
#	yield(get_tree().create_timer(0.5),"timeout");
#	NoteLabel.text=""	

func _check():
	_disable_all(true)
	$Timer.stop()
	print("PressedOrder:",pressedOrder)
	var current_index = pressedOrder.size()-1
	has_lost = pressedOrder[current_index] != colorOrder[current_index]
	if has_lost:
		_lose()
		
	elif !has_lost && !pressedOrder.size()==current_level :
		print("Expected:",notesOrder[pressedOrder.size()-1])
#		yield(_show_note(notesOrder[pressedOrder.size()-1]),"completed")
		yield(_listen_note(notesOrder[pressedOrder.size()-1]),"completed")
		_disable_all(false)
		$Timer.start(countdownTime)
		
	if !has_lost && pressedOrder.size()==current_level:
		_win()

func _listen_note(note):
	is_listening = true
	notes_sampled=[0,0,0,0,0,0,0]
	NoteLabel.text = note #Previous check note
	get_tree().call_group("Buttons", "countdown", countdownTime)
	$Sampler.start()
	yield(RedButton,"idle")
	$Sampler.stop()
	NoteLabel.text="" #Previous check note
	_check_note()
	is_listening = false

func _check_note():
	var sampled_note_index = notes_sampled.find(notes_sampled.max())
	
	print(notes_sampled)
	
	print("Sampled:",notes_FrBg.keys()[sampled_note_index])
	print("Comparison:",notes_FrBg.keys()[sampled_note_index] == notesOrder[pressedOrder.size()-1])
	if notes_FrBg.keys()[sampled_note_index] == notesOrder[pressedOrder.size()-1]:
		return
	else:
		_lose()

func _lose():
	print("You Loose, Looser :c")
	_disable_all(true)
	feedbackPlayer.stream = loseTone;
	
	RedButton.wrong(feedbackPlayer)
	YellowButton.wrong(feedbackPlayer)
	BlueButton.wrong(feedbackPlayer)
	yield(GreenButton.wrong(feedbackPlayer),"completed")
	
	_create_game()

func _win():
	_disable_all(true)
	feedbackPlayer.stream = winTone;
	
	RedButton.glow(feedbackPlayer)
	YellowButton.glow(feedbackPlayer)
	BlueButton.glow(feedbackPlayer)
	yield(GreenButton.glow(feedbackPlayer),"completed")
	
	_start_level(current_level + 1)

func _disable_all(disabled):
	RedButton.disabled = disabled
	YellowButton.disabled = disabled
	BlueButton.disabled = disabled
	GreenButton.disabled = disabled

func _on_button_hit(id):
	pressedOrder.append(id)
	_check()

func _on_Timer_timeout():
	_lose()

func _in_tune_val(var note):
	
	var furtherOctave = 1
	var centralHz = notes_FrBg[note]
	
	var total_frec = spectrum.get_magnitude_for_frequency_range(floor(centralHz),ceil(centralHz)).length()
	
	for m in furtherOctave:
		var octaveHz = centralHz * pow(2, furtherOctave)
		total_frec += spectrum.get_magnitude_for_frequency_range(floor(octaveHz),ceil(octaveHz)).length()
		octaveHz = centralHz * pow(2,-furtherOctave)
		total_frec += spectrum.get_magnitude_for_frequency_range(floor(octaveHz),ceil(octaveHz)).length()
		
	return total_frec;

func _on_Sampler_timeout():
	if notes_highest.find(notes_highest.max()) != 0 :
		notes_sampled[notes_highest.find(notes_highest.max())] += 1
	notes=[0,0,0,0,0,0,0]
	notes_highest=[0,0,0,0,0,0,0]

func _on_toggle_pause():
	var is_paused = get_tree().paused
	if(is_paused):
		$PausedMenu.hide()
	else:
		$PausedMenu.popup()
	get_tree().paused = !is_paused


func _on_restart():
	_on_toggle_pause()
	_create_game()


func _on_main_menu():
	_on_toggle_pause()
	var main_menu = load("res://splash_screen.tscn")
	get_tree().change_scene_to(main_menu)
