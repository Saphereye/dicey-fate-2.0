extends Node2D


func _ready() -> void:
	$AnimationPlayer.play("Idle")

func _on_Area2D_area_entered(area: Area2D) -> void:
	print("Game Over")
	$Area2D.disconnect("area_entered", self, "_on_Area2D_area_entered")
	Data.next_scene()
