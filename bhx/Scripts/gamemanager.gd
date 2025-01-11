extends Node

var tiles: Array[Tile]

enum TileType {
	FOREST,
	WATER
}

enum BurnState {
	NONE,
	LOW,
	MEDIUM,
	HIGH,
	BURNT
}
