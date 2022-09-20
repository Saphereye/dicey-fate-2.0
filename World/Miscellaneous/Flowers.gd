extends Node2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	$Sprite.flip_h = [true, false][rng.randi() % 2]
