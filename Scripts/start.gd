extends Control

func StartGame():
	get_tree().change_scene_to_file("res://Scene/level1.tscn")
	print("start game!")
