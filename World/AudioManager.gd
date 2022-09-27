extends Node2D

func _ready() -> void:
	play("background")

func play(args: String) -> void:
	match args:
		"background":
			$BackgroundMusic.play()
		"player_hurt":
			$PlayerHurt.play()
		"credits":
			$Credits.play()
			$BackgroundMusic.playing = false
