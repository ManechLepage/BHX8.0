class_name TileManager
extends Node2D

var map: Array[Array]
@export var params: GeneratorParams
@export var radial_gradient: GradientTexture2D
var noise: Noise

func _ready() -> void:
	params.seed = randi_range(0, 100000000000000)
	noise = FastNoiseLite.new()
	noise.seed = params.seed
	noise.noise_type = params.noise_type
	radial_gradient.height = params.dimensions.y
	radial_gradient.width = params.dimensions.x
	map = generate()

func generate() -> Array[Array]:
	var generated_map: Array[Array] = []
	
	for y in range(params.dimensions[1]):
		generated_map.append([])
		for x in range(params.dimensions[0]):
			var tile: Tile = Gamemanager.Tile()
			var position: Vector2i = Vector2i(x, y)
			tile.type = get_tile_type(position)
			tile.burn_state = Gamemanager.BurnState.NONE
			tile.position = position
			generated_map[-1].append(tile)
	
	return generated_map

func get_tile_type(position: Vector2i) -> Gamemanager.TileType:
	var value: float = noise.get_noise_2d(position.x / params.scale, position.y / params.scale)
	if value > -0.2:
		return Gamemanager.TileType.FOREST
	else:
		return Gamemanager.TileType.WATER

func get_center_proximity(position: Vector2i) -> float:
	return radial_gradient.get_image().get_pixel(position.x, position.y).a
