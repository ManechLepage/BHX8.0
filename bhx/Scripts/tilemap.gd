class_name TileManager
extends Node2D

var map: Array[Tile]
@export var params: GeneratorParams
@export var radial_gradient: GradientTexture2D
var noise: FastNoiseLite
var noise2: FastNoiseLite
var noise_plains: FastNoiseLite
@onready var ground: TileMapLayer = $Ground
@onready var ground_cover: TileMapLayer = $GroundCover

var offset: Vector2i

func _ready() -> void:
	params.seed = randi_range(0, 100000000000000)
	noise = FastNoiseLite.new()
	noise.seed = params.seed
	noise.noise_type = params.noise_type
	
	noise2 = FastNoiseLite.new()
	noise2.seed = params.seed * 2
	noise2.noise_type = params.noise_type
	
	noise_plains = FastNoiseLite.new()
	noise_plains.seed = params.seed * 3
	noise_plains.noise_type = params.noise_type
	
	radial_gradient.height = params.dimensions.y
	radial_gradient.width = params.dimensions.x
	map = generate()
	offset = params.dimensions / -2
	
func _process(delta: float) -> void:
	update_tile_map(map)

func generate() -> Array[Tile]:
	var generated_map: Array[Tile] = []
	
	for y in range(params.dimensions[1]):
		for x in range(params.dimensions[0]):
			var tile: Tile = Tile.new()
			var position: Vector2i = Vector2i(x, y)
			tile.type = get_tile_type(position)
			tile.burn_state = Gamemanager.BurnState.NONE
			tile.position = position
			generated_map.append(tile)
	
	return generated_map

func get_tile_type(position: Vector2i) -> Gamemanager.TileType:
	var used_position: Vector2 = Vector2(position.x, position.y / 2)
	var value1: float = noise.get_noise_2dv(used_position / params.scale * 5)
	var value2: float = noise.get_noise_2dv(used_position / params.scale * 20)
	
	var value: float = value1 * 0.75 + value2 * 0.25
	var forest_intensity: float = get_center_proximity(position) * 1.25 - 1
	# forest_intensity = 0: value += -1, forest_intensity = 1, value += 0.15
	
	value -= forest_intensity * 1;
	
	if value > 0.4:
		if noise_plains.get_noise_2dv(used_position / params.scale * 50) > -0.2:
			return Gamemanager.TileType.FOREST
		else:
			return Gamemanager.TileType.PLAINS
	else:
		return Gamemanager.TileType.WATER

func get_center_proximity(position: Vector2i) -> float:
	return radial_gradient.get_image().get_pixel(position.x, position.y).r

func update_tile_map(tiles: Array[Tile]) -> void:
	var atlas_coords: Vector2i
	for tile in ground.get_used_cells():
		ground.erase_cell(tile)
	for tile in ground_cover.get_used_cells():
		ground_cover.erase_cell(tile)
	
	for tile in tiles:
		if tile.type == Gamemanager.TileType.FOREST or tile.type == Gamemanager.TileType.PLAINS:
			atlas_coords = Vector2i(0, 1)
		else:
			atlas_coords = Vector2i(0, 2)
		ground.set_cell(tile.position + offset, 0, atlas_coords)
		if tile.type == Gamemanager.TileType.FOREST:
			ground_cover.set_cell(tile.position + offset, 0, Vector2i(0, 0))
