class_name Game
extends Node

@export var params: GeneratorParams
const DIR_SPEED: float = 1
const STRENGTH_SPEED: float = 1 
const BURN_THRESHOLD: float = 4
var tiles: Array[Tile]
var wind_orientation: float
var dir_noise: FastNoiseLite
var wind_strength: float
var strength_noise: FastNoiseLite
var wind: Vector2
var dryness: float
var tick: int = 0

const tick_multiplier: float = 0.95

enum TileType {
	FOREST,
	PLAINS,
	WATER
}

enum BurnState {
	NONE,
	LOW,
	MEDIUM,
	HIGH,
	BURNT
}

func get_forest_tiles() -> Array[Tile]:
	var forest_tiles: Array[Tile]
	for tile in tiles:
		if tile.type == TileType.FOREST:
			forest_tiles.append(tile)
	return forest_tiles

func reset() -> void:
	tick = 0
	dir_noise = FastNoiseLite.new()
	strength_noise = FastNoiseLite.new()
	dir_noise.seed = randi_range(0, 1000)
	strength_noise.seed = randi_range(0, 1000)
	dir_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	strength_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	for tile in tiles:
		tile.heat = 0
		tile.BurnState = BurnState.NONE
	
func update() -> void:
	tick += 1
	update_wind()
	update_burn_state()

func update_wind() -> void:
	wind_orientation = (dir_noise.get_noise_1d(tick * DIR_SPEED) + 1) * PI
	wind_strength = (strength_noise.get_noise_1d(tick * STRENGTH_SPEED) + 1) / 2
	wind = Vector2(wind_strength * cos(wind_orientation), wind_strength * sin(wind_orientation))

func update_burn_state() -> void:
	#the probability for a tile to increase its burn state depends on the following factors:
	# - the current burn state
	# - the burn states of the adjacent tiles, weighed by the wind direction
	# - the wind strength
	for forest_tile in get_forest_tiles():
		if forest_tile.burn_state == BurnState.BURNT:
			continue
		#find the total heat
		var total_heat: float = 0
		for pos in forest_tile.get_neighbours():
			var tile: Tile = get_tree().get_first_node_in_group("TileMap").map[pos.y * params.dimensions[0] + pos.x]
			if (tile.type == TileType.FOREST):
				var dir: Vector2 = pos - forest_tile.position
				#rescale diagonals
				if (dir.x != 0 and dir.y != 0):
					dir /= sqrt(2)
				total_heat += maxf(tile.heat / 10, wind.dot(dir) * tile.heat)
		#the increase in heat is dependent on the total_heat
		var normal_sample: float = 0
		for i in range(12):
			normal_sample += randf()
		normal_sample = normal_sample / 12
		forest_tile.heat += minf(0.2, 2 * total_heat * (normal_sample / 12))
		if forest_tile.heat < 0.2:
			forest_tile.burn_state = BurnState.NONE
		elif forest_tile.heat < 0.4:
			forest_tile.burn_state = BurnState.LOW
		elif forest_tile.heat < 0.8:
			forest_tile.burn_state = BurnState.MEDIUM
		else:
			forest_tile.burn_state = BurnState.HIGH
		forest_tile.accumulated_heat += forest_tile.heat
		if forest_tile.accumulated_heat > BURN_THRESHOLD:
			forest_tile.burn_state = BurnState.HIGH
		
