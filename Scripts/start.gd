extends Control

func StartGame():
	get_tree().change_scene_to_file("res://Scene/BattleScene.tscn")
	print("start game!")
