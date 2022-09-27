extends Node2D

signal level_finished


func _ready() -> void:
	$AnimationPlayer.play("Idle")

func _on_Area2D_area_entered(_area: Area2D) -> void:
	print("Game Over")
	$Area2D.disconnect("area_entered", self, "_on_Area2D_area_entered")
	emit_signal("level_finished")
