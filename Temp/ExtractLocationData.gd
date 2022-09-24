extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var simple_generation_data_array = []
var excess_randomness_data_array = []
var top_spikes_data_array = []
var bottom_spikes_data_array = []
var fauna_data_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile_map = $"Dice Room"
	print(tile_map)
	for x in range(100):
		for y in range(100):
			if tile_map.get_cell(x, y) == 0:
				simple_generation_data_array.append([x, y])
			if tile_map.get_cell(x, y) == 1:
				excess_randomness_data_array.append([x, y])
			if tile_map.get_cell(x, y) == 2:
				top_spikes_data_array.append([x, y])
			if tile_map.get_cell(x, y) == 6:
				bottom_spikes_data_array.append([x, y])
			if tile_map.get_cell(x, y) == 7:
				fauna_data_array.append([x, y])
	print('[', simple_generation_data_array, ', ', excess_randomness_data_array, ',', top_spikes_data_array, ',', bottom_spikes_data_array, ',', fauna_data_array, ',', 16, ',', 16, '],')
