extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_MainMenu_button_down() -> void:
	get_tree().change_scene("res://World/Main Menu.tscn")


func _on_Level0_button_down() -> void:
	Data.current_scene_index = 0
	Data.current_player_pos = Vector2(240, 184)
	get_tree().change_scene("res://World/Levels/Level 0.tscn")


func _on_Resume_button_down() -> void:
	get_tree().change_scene(Data.scenes[Data.current_scene_index])


func _on_Settings_button_down() -> void:
	get_tree().change_scene("res://World/Settings.tscn")


func _on_Level1_button_down() -> void:
	Data.current_scene_index = 1
	Data.current_player_pos = Vector2(320, 72)
	get_tree().change_scene("res://World/Levels/Level 1.tscn")
