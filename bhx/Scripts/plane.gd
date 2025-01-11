class_name Plane1
extends Node

@onready var tilemap: TileManager = $"../Tilemap"

@export var plane: PackedScene

func plane_function(map: Array[Tile], center: Vector2, only_center: bool=false):
	var lowest_y: int = 200
	var lowest_tile: Tile
	for tile in map:
		if tile.position.y < lowest_y:
			lowest_y = tile.position.y
			lowest_tile = tile
	var plane_scene = plane.instantiate()
	get_parent().add_child(plane_scene)
	plane_scene.position = tilemap.ground.map_to_local(lowest_tile.position)
	
	
	Sound.plane()
	var tiles: Array[Tile] = []
	var tileManager: TileManager = get_tree().get_first_node_in_group("TileMap")

	for y in range(0, tileManager.params.dimensions.y):
		var position: Vector2 = Vector2(center.x + int((center.y - y) / 2), y)
		if (center.y - y) >= 0:
			position += Vector2(1, 0)

		if int(center.y) % 2 != 0 and y % 2 == 0:
			position += Vector2(1, 0)
		
		if int(center.y) % 2 != 0 and (center.y - y) < 0:
			if y % 2 == 0:
				position += Vector2(-1, 0)
			else:
				position += Vector2(1, 0)
		
		if center.y - y < 0:
			if y % 2 == 0:
				position -= Vector2(-1, 0)
		
		if not (position.x < 0 or position.x >= tileManager.params.dimensions.x or position.y < 0 or position.y >= tileManager.params.dimensions.y):
			tiles.append(tileManager.get_tile_from_position(map, position))
	
	for tile in tiles:
		if not only_center:
			# tile.type = Gamemanager.TileType.PLAINS
			tile.heat = 0
			tile.burn_state = Gamemanager.BurnState.NONE
		else:
			# tile.type = Gamemanager.TileType.PLAINS
			tile.heat *= 0
			tile.burn_state = Gamemanager.BurnState.NONE
	
	if not only_center:
		var center_side_1: Vector2 = center + Vector2(1, 0)
		var center_side_2: Vector2 = center + Vector2(-1, 0)
		
		for c in [center_side_1, center_side_2]:
			plane_function(map, c, true)
