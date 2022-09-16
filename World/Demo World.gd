extends Node2D

enum TEMPLATES { 
	I,
	O,
	T,
	X
}

var templates = [
	TEMPLATES.I,
	#TEMPLATES.O,
	#TEMPLATES.X,
	#TEMPLATES.T
]

var rng = RandomNumberGenerator.new()

export(int) var WIDTH = 100
export(int) var HEIGHT = 5
export(float, 1) var peak_threshhold
export(float, 1) var valley_threshhold

func _ready() -> void:
	for i in range(10):
		match templates[randi() % templates.size()]:
			TEMPLATES.I:
				I_template(i * 4, 0)
			TEMPLATES.O:
				O_template(i * 4, 0)
#			TEMPLATES.X:
#				pass

func I_template(x: int, y: int):
	for j in range(0,3,2):
		for i in range(0,4,2):
			$TileMap.set_cell(x + i, y + j, 0)
			$TileMap.set_cell(x + i + 1, y + j, 0)
			$TileMap.set_cell(x + i, y + j+1, 0)
			$TileMap.set_cell(x + i + 1, y + j+1, 0)
	rng.randomize()
	for i in range(0,4,2):
		var rand = rng.randf()
		if rand >= peak_threshhold:
			$TileMap.set_cell(x + i, y - 1, 0)
			$TileMap.set_cell(x + i + 1, y - 1, 0)
		elif rand <= valley_threshhold:
			$TileMap.set_cell(x + i, y , -1)
			$TileMap.set_cell(x + i + 1, y , -1)
	$TileMap.update_bitmask_region(Vector2(x,y), Vector2(x+4, y+2))

func O_template(x: int, y: int):
	for j in range(4):
		for i in range(4):
			$TileMap.set_cell(x + i, - y - j + 1, 0)
	$TileMap.update_bitmask_region(Vector2(x,y), Vector2(x+4, y-4))

func T_template(x: int, y: int):
	for j in range(4):
		for i in range(2):
			$TileMap.set_cell(x + i, y + j, 0)
	$TileMap.update_bitmask_region(Vector2(x,y), Vector2(x+2, y+4))

