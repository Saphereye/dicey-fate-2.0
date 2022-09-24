extends Node2D


func _on_Area2D_area_entered(area: Area2D) -> void:
	$AnimationPlayer.play("Collected")
	yield($AnimationPlayer, "animation_finished")
	Data.Player_Health += 1
	self.queue_free()
