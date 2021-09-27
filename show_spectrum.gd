extends Node2D

const VU_COUNT = 16
const FREQ_MAX = 11050.0

const WIDTH = 400
const HEIGHT = 100

const MIN_DB = 60

const notes_FrBg = {"Do":261.63,"Re":293.665,"Mi":329.628,"Fa":349.228,"Sol":391.995,"La":440,"Si":493.883,"Do4":523.25}

var spectrum

var notes=[0,0,0,0,0,0,0,0]

func _draw():
	notes = [_in_tune_val("Do"),_in_tune_val("Re"),_in_tune_val("Mi"),_in_tune_val("Fa"),_in_tune_val("Sol"),_in_tune_val("La"),_in_tune_val("Si"),_in_tune_val("Do4")]
	
	for note in notes:
		notes[notes.find(note)] = null if stepify(note,0.0001) == 0.000 else stepify(note,0.0001)
	
	if notes.max() == null:
		get_node("Notes/Detected_Note").text = "UwU"
#		print("Shhhhh")
	else:
		match notes.find(notes.max()):
			0:
				get_node("Notes/Detected_Note").text = "Do"
#				print("Do")
			1:
				get_node("Notes/Detected_Note").text = "Re"
#				print("Re")
			2:
				get_node("Notes/Detected_Note").text = "Mi"
#				print("Mi")
			3:
				get_node("Notes/Detected_Note").text = "Fa"
#				print("Fa")
			4:
				get_node("Notes/Detected_Note").text = "Sol"
#				print("Sol")
			5:
				get_node("Notes/Detected_Note").text = "La"
#				print("La")
			6:
				get_node("Notes/Detected_Note").text = "Si"
#				print("Yes")
			7:
				get_node("Notes/Detected_Note").text = "Do"
#				print("Do")
	

func _in_tune_val(var note):
	return spectrum.get_magnitude_for_frequency_range(floor(notes_FrBg[note]),ceil(notes_FrBg[note])).length();

func _process(_delta):
	
	update()

func _ready():
#	spectrum = AudioServer.get_bus_effect_instance(0,0)
	spectrum = AudioServer.get_bus_effect_instance(3,0)
	
