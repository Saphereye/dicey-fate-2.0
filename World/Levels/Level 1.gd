extends Node2D

var transition_time: float = 2.0

func _ready() -> void:
	$AnimationPlayer.play("Title")
	Data.current_scene_index = 1
	print(Data.current_player_pos[1])
	print($Positions/StartingPos.position)
	if Data.current_player_pos[1] != $Positions/StartingPos.position:
		match Data.current_checkpoint:
			1:
				$Die/Dice.roll_dice_acting()
			2:
				$Die/Dice2.roll_dice_acting()
	$Player.position = Data.current_player_pos[1]

func _process(delta: float) -> void:
	if $FadeTimer.get_time_left() != 0:
		$FadingCanvas/ColorRect.color = Color(
			0.0,
			0.0,
			0.0,
			1 - $FadeTimer.get_time_left()/transition_time
		)

func _on_Dice_difficulty_changed() -> void:
	Data.current_checkpoint = 1
	Data.current_player_pos[1] = $Positions/Checkpoint1.position
	print("Reached checkpoint 1")

func _on_Level_Finish_Beacon_level_finished() -> void:
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	Data.next_scene()

func _on_Dice2_difficulty_changed() -> void:
	Data.current_checkpoint = 2
	Data.current_player_pos[1] = $Positions/Checkpoint2.position
	print("Reached checkpoint 2")

