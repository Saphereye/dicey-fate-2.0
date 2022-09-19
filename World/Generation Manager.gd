# Conditional export variable : https://github.com/godotengine/godot-proposals/issues/2582#issuecomment-817194312
tool
extends Node2D

export(bool) var is_allowed_horizontal = true
export(bool) var is_present_fauna = true

export(bool) var is_geographical_variation = true setget set_geo_variation
var variation_frequency: float setget set_variation_frequency

func set_geo_variation(p_pickable) -> void:
	is_geographical_variation = p_pickable
	property_list_changed_notify()

func set_variation_frequency(value) -> void:
	variation_frequency = clamp(value, 0, 1)

func _get_property_list() -> Array:
	var list = []
	if is_geographical_variation:
		list.push_back(
			{ name = "variation_frequency", type =  TYPE_REAL}
		)
	return list

var rng = RandomNumberGenerator.new()

var current_pos: Vector2 = Vector2.ZERO

var templates: Dictionary = {
	# First list gives position of all tiles
	# Second list gives positio of all possible variations
	# Third element is widht
	# Fourth is height
	"─" : [
		[
			[0, 0],[0, 1],[0, 2],[0, 3],[0, 10],[0, 11],[0, 12],[0, 13],[0, 14],[0, 15],[1, 0],[1, 1],[1, 2],[1, 3],[1, 10],[1, 11],[1, 12],[1, 13],[1, 14],[1, 15],[2, 0],[2, 1],[2, 10],[2, 11],[2, 13],[2, 14],[2, 15],[3, 0],[3, 1],[3, 10],[3, 11],[3, 13],[3, 14],[3, 15],[4, 0],[4, 1],[4, 10],[4, 11],[4, 12],[4, 13],[4, 14],[4, 15],[5, 0],[5, 1],[5, 2],[5, 10],[5, 11],[5, 12],[5, 13],[5, 14],[5, 15],[6, 0],[6, 1],[6, 2],[6, 10],[6, 11],[6, 12],[6, 13],[6, 14],[6, 15],[7, 0],[7, 1],[7, 2],[7, 3],[7, 4],[7, 10],[7, 11],[7, 12],[7, 14],[7, 15],[8, 0],[8, 1],[8, 2],[8, 3],[8, 4],[8, 10],[8, 11],[8, 12],[8, 14],[8, 15],[9, 0],[9, 1],[9, 2],[9, 10],[9, 11],[9, 12],[9, 13],[9, 14],[9, 15],[10, 0],[10, 1],[10, 2],[10, 10],[10, 11],[10, 12],[10, 13],[10, 14],[10, 15],[11, 0],[11, 1],[11, 10],[11, 11],[11, 12],[11, 13],[11, 14],[11, 15],[12, 0],[12, 1],[12, 10],[12, 11],[12, 13],[12, 14],[12, 15],[13, 0],[13, 1],[13, 10],[13, 11],[13, 13],[13, 14],[13, 15],[14, 0],[14, 1],[14, 2],[14, 3],[14, 4],[14, 10],[14, 11],[14, 12],[14, 13],[14, 14],[14, 15],[15, 0],[15, 1],[15, 2],[15, 3],[15, 4],[15, 10],[15, 11],[15, 12],[15, 13],[15, 14],[15, 15],
		],
		[
			[0, 4],[0, 9],[1, 9],[2, 2],[2, 9],[2, 12],[3, 2],[3, 9],[4, 9],[5, 3],[5, 9],[6, 9],[7, 5],[7, 9],[7, 13],[8, 9],[9, 3],[9, 9],[10, 9],[11, 2],[11, 9],[12, 2],[12, 9],[12, 12],[13, 9],[14, 5],[14, 9],
		],
		16,
		16
	],
	
	"┐" : [
		[
			 [0, 0],[0, 1],[0, 10],[0, 11],[0, 12],[0, 13],[0, 14],[0, 15],[1, 0],[1, 1],[1, 10],[1, 11],[1, 12],[1, 13],[1, 14],[1, 15],[2, 0],[2, 1],[2, 10],[2, 11],[2, 13],[2, 14],[2, 15],[3, 0],[3, 1],[3, 10],[3, 11],[3, 13],[3, 14],[3, 15],[4, 0],[4, 1],[4, 10],[4, 11],[4, 12],[4, 13],[4, 14],[4, 15],[5, 0],[5, 1],[5, 10],[5, 11],[5, 12],[5, 13],[5, 14],[5, 15],[6, 0],[6, 1],[7, 0],[7, 1],[8, 0],[8, 1],[9, 0],[9, 1],[10, 0],[10, 1],[10, 10],[10, 11],[10, 12],[10, 13],[10, 14],[10, 15],[11, 0],[11, 1],[11, 10],[11, 11],[11, 12],[11, 13],[11, 14],[11, 15],[12, 0],[12, 1],[12, 10],[12, 11],[12, 14],[12, 15],[13, 0],[13, 1],[13, 10],[13, 11],[13, 14],[13, 15],[14, 0],[14, 1],[14, 2],[14, 3],[14, 4],[14, 5],[14, 6],[14, 7],[14, 8],[14, 9],[14, 10],[14, 11],[14, 12],[14, 13],[14, 14],[14, 15],[15, 0],[15, 1],[15, 2],[15, 3],[15, 4],[15, 5],[15, 6],[15, 7],[15, 8],[15, 9],[15, 10],[15, 11],[15, 12],[15, 13],[15, 14],[15, 15],
		],
		[
			[0, 9],[1, 9],[2, 12],[3, 2],[4, 2],[6, 2],[7, 2],[9, 2],[10, 2],[10, 9],[11, 2],[12, 2],[12, 9],[12, 12],[12, 13],
		],
		16,
		16
	],
	
	"│" : [
		[
			[0, 0],[0, 1],[0, 2],[0, 3],[0, 4],[0, 5],[0, 6],[0, 7],[0, 8],[0, 9],[0, 10],[0, 11],[0, 12],[0, 13],[0, 14],[0, 15],[1, 0],[1, 1],[1, 2],[1, 3],[1, 4],[1, 5],[1, 6],[1, 7],[1, 8],[1, 9],[1, 10],[1, 11],[1, 12],[1, 13],[1, 14],[1, 15],[2, 0],[2, 1],[2, 2],[2, 3],[2, 4],[2, 5],[2, 6],[2, 7],[2, 8],[2, 10],[2, 11],[2, 12],[2, 13],[2, 14],[2, 15],[3, 0],[3, 1],[3, 2],[3, 3],[3, 4],[3, 5],[3, 6],[3, 7],[3, 8],[3, 10],[3, 11],[3, 12],[3, 13],[3, 14],[3, 15],[4, 3],[4, 4],[4, 5],[4, 13],[4, 14],[4, 15],[5, 3],[5, 4],[5, 5],[5, 13],[5, 14],[5, 15],[6, 3],[6, 4],[6, 5],[6, 13],[6, 14],[6, 15],[7, 3],[7, 4],[7, 5],[7, 8],[7, 9],[7, 10],[7, 13],[7, 14],[7, 15],[8, 8],[8, 9],[8, 10],[9, 8],[9, 9],[9, 10],[10, 8],[10, 9],[10, 10],[11, 8],[11, 9],[11, 10],[12, 0],[12, 1],[12, 3],[12, 4],[12, 5],[12, 6],[12, 7],[12, 8],[12, 9],[12, 10],[12, 11],[12, 12],[12, 13],[12, 14],[12, 15],[13, 0],[13, 1],[13, 3],[13, 4],[13, 5],[13, 6],[13, 7],[13, 8],[13, 9],[13, 10],[13, 11],[13, 12],[13, 13],[13, 14],[13, 15],[14, 0],[14, 1],[14, 2],[14, 3],[14, 4],[14, 5],[14, 6],[14, 7],[14, 8],[14, 9],[14, 10],[14, 11],[14, 12],[14, 13],[14, 14],[14, 15],[15, 0],[15, 1],[15, 2],[15, 3],[15, 4],[15, 5],[15, 6],[15, 7],[15, 8],[15, 9],[15, 10],[15, 11],[15, 12],[15, 13],[15, 14],[15, 15],
		],
		[
			[2, 9],[4, 2],[4, 6],[4, 12],[10, 7],[10, 11],[12, 2],
		],
		16,
		16
	]
}

var template_list = ["─", "┐", "│", "┌", "┘", "└"]

var adjacency: Dictionary = {
	"─" : ["─", "┐"],
	"┐" : ["│"],
	"│" : ["│"]
}

var previous_template = "─"
var current_template = "─"

func _ready() -> void:
#	# Load the templates
#	template_list.append("─")
#	template_list.append("┐")
#	$TileMap.clear()
#
#	# Draw the templates
#	for _i in range(10):
#		rng.randomize()
#		var template = template_list[randi() % template_list.size()]
#		for coor in templates[template][0]:
#			$TileMap.set_cell(current_pos.x + coor[0], current_pos.y + coor[1], 0)
#		for coor in templates[template][1]:
#			if rng.randf() > variation_frequency:
#				$TileMap.set_cell(current_pos.x + coor[0], current_pos.y + coor[1], 0)
#				$TileMap.set_cell(current_pos.x + 1 + coor[0], current_pos.y + coor[1], 0)
#		$TileMap.update_bitmask_region(current_pos, current_pos + Vector2(templates[template][2], templates[template][3]))
#		match template:
#			"─":
#				current_pos += Vector2(templates[template][2], 0)
#			"┐":
#				current_pos += Vector2(0, templates[template][3])
	$TileMap.clear()
	for _i in range(10):
		rng.randomize()
		print(current_template)
		for coor in templates[current_template][0]:
			$TileMap.set_cell(current_pos.x + coor[0], current_pos.y + coor[1], 0)
		for coor in templates[current_template][1]:
			if rng.randf() > variation_frequency:
				$TileMap.set_cell(current_pos.x + coor[0], current_pos.y + coor[1], 0)
				$TileMap.set_cell(current_pos.x + 1 + coor[0], current_pos.y + coor[1], 0)
		$TileMap.update_bitmask_region(current_pos, current_pos + Vector2(templates[current_template][2], templates[current_template][3]))
		match current_template:
			"─":
				current_pos += Vector2(templates[current_template][2], 0)
			"┐":
				current_pos += Vector2(0, templates[current_template][3])
			"│":
				current_pos += Vector2(0, templates[current_template][3])
		current_template = list_rand_element(adjacency[previous_template])
		previous_template = current_template
		
func list_rand_element(list) -> String:
	return list[randi() % list.size()]
