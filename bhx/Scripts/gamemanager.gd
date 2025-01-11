class_name Game
extends Node

var tiles: Array[Tile]
var wind_orientation: float
var wind_strength: float
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

func update() -> void:
	tick += 1
	update_wind()

func update_wind() -> void:
	dryness *= tick_multiplier
