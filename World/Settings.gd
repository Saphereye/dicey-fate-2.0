extends Node2D


func _on_HSlider_value_changed(value: float) -> void:
	AudioManager.set_volume(value)
