class_name Game
extends Node

const DIR_SPEED: float = 4
const STRENGTH_SPEED: float = 8
const BURN_THRESHOLD: float = 10
var wind_orientation: float
var dir_noise: FastNoiseLite
var difficulty: float
var difficulty_multiplier: float
var min_temp: float
var wind: Vector2
var tick: int = 0
var did_win: bool = false


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
	for tile in get_tree().get_first_node_in_group("TileMap").map:
		if tile.type == TileType.FOREST:
			forest_tiles.append(tile)
	return forest_tiles

func reset(diff = 2, mint = 0.45, decay = 0.8) -> void:
	tick = 0
	difficulty = diff
	min_temp = mint
	difficulty_multiplier = decay
	dir_noise = FastNoiseLite.new()
	dir_noise.seed = randi_range(0, 1000)
	dir_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	for tile in get_tree().get_first_node_in_group("TileMap").map:
		tile.heat = 0
		tile.burn_state = BurnState.NONE

func update() -> void:
	tick += 1
	update_wind()
	update_burn_state()
	
	if not did_win:
		var tileMap = get_tree().get_first_node_in_group("TileMap")
		tileMap.update_if_player_win()

func update_wind() -> void:
	difficulty = maxf(difficulty * difficulty_multiplier, min_temp)
	print(difficulty)
	wind_orientation = (dir_noise.get_noise_1d(tick * DIR_SPEED) + 1) * PI
	wind = Vector2(cos(wind_orientation), sin(wind_orientation))

func update_burn_state() -> void:
	#the probability for a tile to increase its burn state depends on the following factors:
	# - the current burn state
	# - the burn states of the adjacent tiles, weighed by the wind direction
	# - the wind strength
	for tile in get_tree().get_first_node_in_group("TileMap").map:
		if tile.type != TileType.FOREST or tile.burn_state == BurnState.BURNT:
			continue
		#find the total heat
		var target_heat: float = 0
		for idx in tile.get_neighbours():
			var neighbour: Tile = get_tree().get_first_node_in_group("TileMap").map[idx]
			if (neighbour.type == TileType.FOREST and neighbour.heat != 0):
				var dir: Vector2 = Vector2(neighbour.position - tile.position).normalized()
				#rescale diagonals
				target_heat += ((wind.dot(dir) + 1) / 2 * neighbour.heat)
		target_heat *= difficulty
		var normal_sample: float = 0
		for i in range(12):
			normal_sample += randf()
		normal_sample = normal_sample / 12
		#print(normal_sample)
		#print(target_heat, " ", tile.heat)
		tile.new_heat = min(1, max(tile.heat / 2, tile.heat * normal_sample + target_heat * (1 - normal_sample)))

		if tile.heat < 0.2:
			tile.burn_state = BurnState.NONE
		elif tile.heat < 0.4:
			tile.burn_state = BurnState.LOW
		elif tile.heat < 0.8:
			tile.burn_state = BurnState.MEDIUM
		else:
			tile.burn_state = BurnState.HIGH
		tile.accumulated_heat += tile.heat
		if tile.accumulated_heat > BURN_THRESHOLD and tile.burn_state != BurnState.NONE:
			tile.burn_state = BurnState.BURNT
			tile.heat = 0
	for tile in get_tree().get_first_node_in_group("TileMap").map:
		tile.heat = tile.new_heat

func output_score(left: int, percentage: float) -> void:
	get_tree().get_first_node_in_group("UI").animate_score(left, round(percentage * 100) / 100)
