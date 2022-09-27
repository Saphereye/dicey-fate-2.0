extends Node

export(int, -1, 6) var Player_Health = 6
export(int, 1, 6) var difficulty = 1

var scenes = ["res://World/Levels/Level 0.tscn", "res://World/End Screen.tscn"]

var current_scene_index: int = 0
var current_player_pos := Vector2(240, 184)


func next_scene():
	current_scene_index += 1
	get_tree().change_scene(scenes[current_scene_index])

func _process(_delta: float) -> void:
	
	if current_scene_index == 1:
		Player_Health = 6
	
	Player_Health = clamp(Player_Health, 0, 6)
	
	if Player_Health == 0:
		Player_Health = 6
		get_tree().change_scene(scenes[current_scene_index])
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://World/Levels.tscn")
