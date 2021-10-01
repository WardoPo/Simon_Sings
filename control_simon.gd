extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_play():
	var simon_scene = load("res://play_simon.tscn")
	get_tree().change_scene_to(simon_scene)

func _on_Play_PauseButton_pressed():
	get_tree().paused = !get_tree().paused
	
	pass # Replace with function body.


func _on_Welcome_about_to_show():
	#get_tree().paused = true
	pass # Replace with function body.
