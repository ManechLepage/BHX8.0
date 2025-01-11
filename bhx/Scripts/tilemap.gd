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
@onready var indicators: TileMapLayer = $Indicatiors

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
	
	Gamemanager.reset()
	
	var forest_tiles: Array[Tile] = Gamemanager.get_forest_tiles()
	forest_tiles.pick_random().heat = 1
	
	offset = params.dimensions / -2
	
	Gamemanager.update()
	update()

func update() -> void:
	update_tile_map(map)
	load_water()

func generate() -> Array[Tile]:
	var generated_map: Array[Tile] = []
	
	for y in range(params.dimensions[1]):
		for x in range(params.dimensions[0]):
			var tile: Tile = Tile.new()
			var position: Vector2i = Vector2i(x, y)
			tile.type = get_tile_type(position)
			tile.params = params
			tile.burn_state = Gamemanager.BurnState.NONE
			tile.position = position
			generated_map.append(tile)
	
	generated_map = add_rivers(generated_map)
	
	return generated_map

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Reset"):
		_ready()

func load_water() -> void:
	for x in range(256):
		for y in range(256):
			if not ground.get_cell_tile_data(Vector2i(x, y) + offset):
				ground.set_cell(Vector2i(x, y) + offset - Vector2i(128, 128), 0, Vector2i(0, 2))

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
	for tile in indicators.get_used_cells():
		indicators.erase_cell(tile)
	
	for tile in tiles:
		if tile.type == Gamemanager.TileType.FOREST or tile.type == Gamemanager.TileType.PLAINS:
			atlas_coords = Vector2i(0, 1)
		else:
			atlas_coords = Vector2i(0, 2)
		ground.set_cell(tile.position + offset, 0, atlas_coords)
		if tile.type == Gamemanager.TileType.FOREST:
			var ground_atlas: Vector2i = Vector2i(int(tile.burn_state), 0)
			ground_cover.set_cell(tile.position + offset, 0, ground_atlas)
			indicators.set_cell(tile.position + offset, 1, ground_atlas - Vector2i(1, 0))

func get_tile_from_position(generated_map: Array[Tile], position: Vector2i) -> Tile:
	var index: int = position.y * params.dimensions.x + position.x
	return generated_map[index]

func get_random_water(water_tiles: Array[Tile]) -> Tile:
	return water_tiles.pick_random()

func get_all_water_tiles(generated_map: Array[Tile]) -> Array[Tile]:
	var all_waters: Array[Tile] = []
	for tile in generated_map:
		all_waters.append(tile)
	return all_waters

func get_all_close_to_land(generated_map: Array[Tile], water_tiles: Array[Tile]) -> Array[Tile]:
	var all_correct_tiles: Array[Tile] = []
	for tile in water_tiles:
		var all_neighbours: Array[Vector2i] = ground.get_surrounding_cells(tile.position)
		for neighbour in all_neighbours:
			if not (neighbour.x < 0 or neighbour.x >= params.dimensions.x or neighbour.y < 0 or neighbour.y >= params.dimensions.y):
				var neighbour_tile: Tile = get_tile_from_position(generated_map, neighbour)
				if neighbour_tile.type != Gamemanager.TileType.WATER:
					all_correct_tiles.append(tile)
					break
	return all_correct_tiles

func get_neighbour_from_angle(generated_map: Array[Tile], tile: Tile, angle: float) -> Tile:
	# Angle values: [-1; 1]
	angle *= 2  # range [-2, 2]
	angle = round(angle)
	var all_neighbours: Array[Vector2i] = ground.get_surrounding_cells(tile.position)
	var index: int = angle + 2
	
	if index == 4:
		index = 0
	
	var tile_position: Vector2i = all_neighbours[index]
	if tile_position.x < 0 or tile_position.x >= params.dimensions.x or tile_position.y < 0 or tile_position.y >= params.dimensions.y:
		tile_position = tile.position
	
	return get_tile_from_position(generated_map, tile_position)

func add_rivers(generated_map: Array[Tile]) -> Array[Tile]:
	var number_of_rivers: int = randi_range(8, 12)
	var all_water_tiles = get_all_water_tiles(generated_map)
	all_water_tiles = get_all_close_to_land(generated_map, all_water_tiles)
	
	for i in range(number_of_rivers):
		var start_water: Tile = get_random_water(all_water_tiles)
		
		var direction_noise: FastNoiseLite = FastNoiseLite.new()
		direction_noise.seed = params.seed + 10 * i
		direction_noise.noise_type = FastNoiseLite.TYPE_PERLIN
		
		var direction_noise2: FastNoiseLite = FastNoiseLite.new()
		direction_noise2.seed = params.seed + 11 * i
		direction_noise2.noise_type = FastNoiseLite.TYPE_PERLIN
		
		var direction1: float
		var direction2: float
		var direction: float
		var step: int = 0
		var number_of_land_tiles: int = 0
		while true:
			direction1 = direction_noise.get_noise_1d(step * 60) * 2.5
			direction2 = direction_noise2.get_noise_1d(step * 5) * 2.5	
			
			direction = direction1 * 0.5 + direction2 * 0.5
			
			var neighbour_in_direction: Tile = get_neighbour_from_angle(generated_map, start_water, direction)
			step += 1
			
			start_water = neighbour_in_direction
			
			if neighbour_in_direction.type != Gamemanager.TileType.WATER:
				number_of_land_tiles += 1
			
			if step > 1000 or (neighbour_in_direction.type == Gamemanager.TileType.WATER) and number_of_land_tiles > 5:
				break
			
			neighbour_in_direction.type = Gamemanager.TileType.WATER
	
	return generated_map


func _on_timer_timeout() -> void:
	Gamemanager.update()
	update()

func delete_forest(position: Vector2i) -> void:
	var tile: Tile = get_tile_from_position(map, position)
	tile.type = Game.TileType.PLAINS
	update()
