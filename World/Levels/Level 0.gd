extends Node2D

var transition_time: float = 5.0

func _ready() -> void:
	print(Data.current_player_pos)
	print($Positions/StartingPos.position)
	if Data.current_player_pos != $Positions/StartingPos.position:
		$Dice.roll_dice_acting()
	$Player.position = Data.current_player_pos

func _process(delta: float) -> void:
	if $FadeTimer.get_time_left() != 0:
		$FadingCanvas/ColorRect.color = Color(
			0.0,
			0.0,
			0.0,
			1 - $FadeTimer.get_time_left()/transition_time
		)

func _on_Dice_difficulty_changed() -> void:
	Data.current_player_pos = $Positions/CheckPoint.position


func _on_Level_Finish_Beacon_level_finished() -> void:
	$FadeTimer.start()


func _on_FadeTimer_timeout() -> void:
	Data.next_scene()
