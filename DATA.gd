extends Node

export(int, -1, 6) var Player_Health = 6
export(int, 1, 6) var difficulty = 1

var scenes = ["res://World/Levels/Level 0.tscn", "res://World/Levels/Level 1.tscn","res://World/End Screen.tscn"]

var current_scene_index: int = 0
var current_player_pos := [Vector2(240, 184), Vector2(320, 72)]
var current_checkpoint = 0

func next_scene():
	current_scene_index += 1
	Data.Player_Health = 6
	get_tree().change_scene(scenes[current_scene_index])
	current_checkpoint = 0

func _process(_delta: float) -> void:	
	Player_Health = clamp(Player_Health, 0, 6)
	
	if Player_Health == 0:
		Player_Health = 6
		get_tree().change_scene(scenes[current_scene_index])
	
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://World/Levels.tscn")
