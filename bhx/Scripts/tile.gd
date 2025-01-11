class_name Tile
extends Resource

var params: GeneratorParams
@export var type: Game.TileType
@export var burn_state: Game.BurnState

var position: Vector2i
var heat: float #between 0 and 1
var new_heat: float
var accumulated_heat: float

func get_neighbours() -> Array[int]:
	var result: Array[int] = []
	for i in [-1, 0, 1]:
		for j in [-1, 0, 1]:
			if not (i == 0 and j == 0):
				var neighbour: Vector2i = Vector2i(position.x + i, position.y + j)
				if (neighbour.x >= 0 and neighbour.x < params.dimensions.x and neighbour.y >= 0 and neighbour.y < params.dimensions.y):
					result.append(int(neighbour.y * params.dimensions.x + neighbour.x))
	return result
