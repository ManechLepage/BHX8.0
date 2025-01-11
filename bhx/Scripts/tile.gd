class_name Tile
extends Resource

var params: GeneratorParams
@export var type: Game.TileType
@export var burn_state: Game.BurnState

var position: Vector2i
var heat: float #between 0 and 1
var new_heat: float
var accumulated_heat: float

var odd_neighbours: Array[Vector2i] = [
	Vector2i(1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 0),
	Vector2i(0, -1),
	Vector2i(1, 1),
	Vector2i(0, 2),
	Vector2i(0, -2),
	Vector2i(1, -1),
]

var even_neighbours: Array[Vector2i] = [
	Vector2i(0, -2),
	Vector2i(0, 2),
	Vector2i(1, 0),
	Vector2i(-1, 0),
	Vector2i(0, 1),
	Vector2i(-1, 1),
	Vector2i(-1, -1),
	Vector2i(0, -1)
]

func get_neighbours() -> Array[int]:
	var result: Array[int] = []
	var neighbours: Array[Vector2i]
	if position.y % 2 == 0:
		neighbours = even_neighbours
	else:
		neighbours = odd_neighbours
	for offset in neighbours:
			var neighbour: Vector2i = Vector2i(position.x + offset.x, position.y + offset.y)
			if (neighbour.x >= 0 and neighbour.x < params.dimensions.x and neighbour.y >= 0 and neighbour.y < params.dimensions.y):
				result.append(int(neighbour.y * params.dimensions.x + neighbour.x))
	return result
