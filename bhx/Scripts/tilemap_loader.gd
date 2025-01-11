extends Node

@onready var gamemanager: Game = $".."

func load_tiles(_tiles: Array[Tile]) -> void:
	gamemanager.tiles = _tiles
