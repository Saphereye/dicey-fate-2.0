extends Node2D


func _on_HSlider_value_changed(value: float) -> void:
	AudioManager.set_volume(value)


func _on_Button_button_down() -> void:
	get_tree().change_scene("res://World/Levels.tscn")
