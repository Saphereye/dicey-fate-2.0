extends Node2D

var transition_time: float = 2.0

# Currently there are 2
var current_checkpoint = 0

func _ready() -> void:
	Data.current_scene_index = 1
	print(Data.current_player_pos)
	print($Positions/StartingPos.position)
	if Data.current_player_pos != $Positions/StartingPos.position:
		match current_checkpoint:
			1:
				$Dice.roll_dice_acting()
			2:
				$Dice2.roll_dice_acting()

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
	current_checkpoint = 1
	Data.current_player_pos = $Positions/Checkpoint1.position

func _on_Level_Finish_Beacon_level_finished() -> void:
	$FadeTimer.start()


func _on_FadeTimer_timeout() -> void:
	Data.next_scene()


func _on_Dice2_difficulty_changed() -> void:
	current_checkpoint = 2
	Data.current_player_pos = $Positions/Checkpoint2.position

