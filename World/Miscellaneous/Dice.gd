extends Node2D

var dice_outcome: int
var rng = RandomNumberGenerator.new()

signal difficulty_changed

func _ready() -> void:
	$Sprite.frame = 72


func roll_dice() -> void:
	$AnimationPlayer.play("Roll")
	$AudioStreamPlayer2D.play()
	yield($AnimationPlayer, "animation_finished")
	
	rng.randomize()
	dice_outcome = (rng.randi() % 6) + 1
	
	$Sprite.frame = (dice_outcome) - 1
	Data.difficulty = dice_outcome
	emit_signal("difficulty_changed")
	$"Player Dice Touch Area/CollisionShape2D".disabled = true
	print("Really rolling the dice")

func roll_dice_acting() -> void:
	$Sprite.frame = (Data.difficulty) - 1
	$"Player Dice Touch Area/CollisionShape2D".disabled = true
	print("Just acting of dice rolling")

func _on_Player_Dice_Touch_Area_area_entered(_area: Area2D) -> void:
	roll_dice()
