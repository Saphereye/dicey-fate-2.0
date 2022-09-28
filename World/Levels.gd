extends Control

func _ready() -> void:
	$RichTextLabel.text = "Current Level : " + str(Data.current_scene_index)

func _on_MainMenu_button_down() -> void:
	get_tree().change_scene("res://World/Main Menu.tscn")


func _on_Level0_button_down() -> void:
	Data.current_scene_index = 0
	Data.current_player_pos[0] = Vector2(240, 184)
	get_tree().change_scene("res://World/Levels/Level 0.tscn")


func _on_Resume_button_down() -> void:
	get_tree().change_scene(Data.scenes[Data.current_scene_index])


func _on_Settings_button_down() -> void:
	get_tree().change_scene("res://World/Settings.tscn")


func _on_Level1_button_down() -> void:
	Data.current_scene_index = 1
	Data.current_player_pos[1] = Vector2(320, 72)
	get_tree().change_scene("res://World/Levels/Level 1.tscn")
