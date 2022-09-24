extends CanvasLayer

func _process(delta: float) -> void:
	$Hearts.rect_size = Vector2(16*Data.Player_Health, 16)
