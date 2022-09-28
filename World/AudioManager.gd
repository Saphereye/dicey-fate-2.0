extends Node2D

func _ready() -> void:
	play("background")

func play(args: String) -> void:
	match args:
		"background":
			$BackgroundMusic.play()
		"player_hurt":
			#$PlayerHurt.playing = false
			$PlayerHurt.play()
		"credits":
			$Credits.play()
			$BackgroundMusic.stop()

func set_volume(value: int) -> void:
	# We get volume in range 0 to 10
	# 0 is mapped to -30dB
	# 10 is mapped to 0 dB
	# Optimal is -10 dB
	var new_volume = (10*value - 50)
	for i in self.get_children():
		print(i)
		i.volume_db = new_volume
	
