extends Node

export(int, -1, 6) var Player_Health = 6
export(int, 1, 6) var difficulty = 1

var scenes = ["res://World/Levels/Level 0.tscn", "res://World/Levels/Level 1.tscn","res://World/End Screen.tscn"]

var current_scene_index: int = 0
var current_player_pos := [Vector2(240, 184), Vector2(320, 72)]
var current_checkpoint = 0

const FILE_NAME = "user://save_file.json"

func _ready() -> void:
	load_file()

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

func save_file() -> void:
	var data = {
		"current_level": current_scene_index,
		"health" : Player_Health,
		"current_checkpoint" : current_checkpoint,
	}

	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(data))
	file.close()
	
func load_file() -> void:
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var _data = parse_json(file.get_as_text())
		file.close()
		if typeof(_data) == TYPE_DICTIONARY:
			var data = _data
			
			current_scene_index = data["current_level"]
			Player_Health = data["health"]
			current_checkpoint = data["current_checkpoint"]
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")
	
