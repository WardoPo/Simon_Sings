extends Control

func _on_play():
	var simon_scene = load("res://play_simon.tscn")
	get_tree().change_scene_to(simon_scene)
