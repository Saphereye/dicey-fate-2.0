extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var simple_generation_data_array = []
var excess_randomness_data_array = []

onready var tile_map = $Vertical

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(100):
		for y in range(100):
			if tile_map.get_cell(x, y) == 0:
				simple_generation_data_array.append([x, y])
			if tile_map.get_cell(x, y) == 1:
				excess_randomness_data_array.append([x, y])
	var simple_string = ''
	var random_string = ''
	for i in simple_generation_data_array:
		simple_string += str(i) + ','
	for i in excess_randomness_data_array:
		random_string += str(i) + ','
	print(simple_string)
	print()
	print(random_string)
