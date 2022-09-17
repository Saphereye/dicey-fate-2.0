# Conditional export variable : https://github.com/godotengine/godot-proposals/issues/2582#issuecomment-817194312
tool
extends Node2D

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
	# Third element is widht
	# Fourth is height
	"horizontal" : [
		[
			[0, 0],[0, 1],[0, 2],[0, 3],[0, 10],[0, 11],[0, 12],[0, 13],[0, 14],[0, 15],[1, 0],[1, 1],[1, 2],[1, 3],[1, 10],[1, 11],[1, 12],[1, 13],[1, 14],[1, 15],[2, 0],[2, 1],[2, 2],[2, 3],[2, 10],[2, 11],[2, 13],[2, 14],[2, 15],[3, 0],[3, 1],[3, 2],[3, 3],[3, 10],[3, 11],[3, 13],[3, 14],[3, 15],[4, 0],[4, 1],[4, 10],[4, 11],[4, 12],[4, 13],[4, 14],[4, 15],[5, 0],[5, 1],[5, 10],[5, 11],[5, 12],[5, 13],[5, 14],[5, 15],[6, 0],[6, 1],[6, 10],[6, 11],[6, 12],[6, 13],[6, 14],[6, 15],[7, 0],[7, 1],[7, 2],[7, 10],[7, 11],[7, 12],[7, 14],[7, 15],[8, 0],[8, 1],[8, 2],[8, 10],[8, 11],[8, 12],[8, 14],[8, 15],[9, 0],[9, 1],[9, 2],[9, 10],[9, 11],[9, 12],[9, 13],[9, 14],[9, 15],[10, 0],[10, 1],[10, 10],[10, 11],[10, 12],[10, 13],[10, 14],[10, 15],[11, 0],[11, 1],[11, 10],[11, 11],[11, 12],[11, 13],[11, 14],[11, 15],[12, 0],[12, 1],[12, 2],[12, 3],[12, 10],[12, 11],[12, 13],[12, 14],[12, 15],[13, 0],[13, 1],[13, 2],[13, 3],[13, 10],[13, 11],[13, 13],[13, 14],[13, 15],[14, 0],[14, 1],[14, 2],[14, 3],[14, 10],[14, 11],[14, 12],[14, 13],[14, 14],[14, 15],[15, 0],[15, 1],[15, 2],[15, 3],[15, 10],[15, 11],[15, 12],[15, 13],[15, 14],[15, 15],
		],
		[
			[0, 4],[0, 9],[2, 4],[2, 12],[4, 2],[6, 9],[7, 3],[7, 13],[8, 3],[8, 9],[10, 2],[12, 4],[12, 12],[14, 4],[14, 9],
		],
		16,
		16
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
				$TileMap.update_bitmask_region(current_pos, current_pos + Vector2(templates["horizontal"][2], templates["horizontal"][3]))
				current_pos += Vector2(templates["horizontal"][2], 0)
