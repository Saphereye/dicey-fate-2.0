extends Node

export(int, 0, 6) var Player_Health = 6
# Difficulty goes fomr 0 to 10
export(int, 1, 6) var difficulty = 1

var scenes = ["res://World/Levels/Level 0.tscn", "res://World/End Screen.tscn"]

var current_scene_index: int = 0

func next_scene():
	current_scene_index += 1
	get_tree().change_scene(scenes[current_scene_index])
