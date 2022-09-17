# Conditional export variable : https://github.com/godotengine/godot-proposals/issues/2582#issuecomment-817194312
tool
extends Node2D

export(int,0,10) var difficulty
export(bool) var is_allowed_horizontal = true
export(bool) var is_present_fauna = true

export(bool) var is_geographical_variation = true setget set_geo_variation
var variation_frequency: float setget set_variation_frequency

func set_geo_variation(p_pickable):
	is_geographical_variation = p_pickable
	property_list_changed_notify()

func set_variation_frequency(value):
	variation_frequency = clamp(value, 0, 1)

func _get_property_list() -> Array:
	var list = []
	if is_geographical_variation:
		list.push_back(
			{ name = "variation_frequency", type =  TYPE_REAL}
		)
	return list

var rng = RandomNumberGenerator.new()

var template_list = []

var current_pos = Vector2(0,0)

var templates = {
	# First list gives position of all tiles
	# Second list gives positio of all possible variations
	"horizontal" : [
		[
			[0,0],[1,0],[2,0],[3,0],
			[0,1],[1,1],[2,1],[3,1],
			[0,2],[1,2],[2,2],[3,2]
		],
		[
			[0,-1],[2,-1]
		]
	]
}

func _ready() -> void:
	# Load the templates
	template_list.append("horizontal")
	$TileMap.clear()
	
	# Draw the templates
	for _i in range(10):
		rng.randomize()
		match template_list[randi() % template_list.size()]:
			"horizontal":
				for coor in templates["horizontal"][0]:
					$TileMap.set_cell(current_pos.x + coor[0], current_pos.y + coor[1], 0)
				for coor in templates["horizontal"][1]:
					if rng.randf() > variation_frequency:
						$TileMap.set_cell(current_pos.x + coor[0], current_pos.y + coor[1], 0)
						$TileMap.set_cell(current_pos.x + 1 + coor[0], current_pos.y + coor[1], 0)
				$TileMap.update_bitmask_region(current_pos, current_pos + Vector2(4, 1))
				current_pos += Vector2(4, 0)
