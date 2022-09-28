extends Node2D


func _on_Button_button_down() -> void:
	get_tree().change_scene("res://World/Levels.tscn")


func _on_Button2_button_down() -> void:
	Data.save_file()
	get_tree().quit()
