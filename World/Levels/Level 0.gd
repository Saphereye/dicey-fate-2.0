extends Node2D

var transition_time: float = 2.0

func _ready() -> void:
	Data.current_scene_index = 0
	print(Data.current_player_pos[0])
	print($Positions/StartingPos.position)
	if Data.current_player_pos[0] != $Positions/StartingPos.position:
		$Dice.roll_dice_acting()
	$Player.position = Data.current_player_pos[0]
	$AnimationPlayer.play("Title")

func _on_Dice_difficulty_changed() -> void:
	Data.current_player_pos[0] = $Positions/CheckPoint.position

func _on_Level_Finish_Beacon_level_finished() -> void:
	$AnimationPlayer.play("FadeOut")
	yield($AnimationPlayer, "animation_finished")
	Data.next_scene()
