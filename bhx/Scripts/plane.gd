class_name Plane1
extends Node

@onready var tilemap: TileManager = $"../Game/Tilemap"

@export var plane: PackedScene

func plane_function(map: Array[Tile], center: Vector2, only_center: bool=false):
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
		if tile.type == Gamemanager.TileType.FOREST and tile.burn_state != Gamemanager.BurnState.BURNT:
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
		
		var direction: Vector2 = Vector2(tiles[-1].position).direction_to(Vector2(tiles[0].position))
		var plane_scene = plane.instantiate()
		get_parent().add_child(plane_scene)
		plane_scene.position = tilemap.ground.map_to_local(tiles[0].position)  - (direction * 100) - Vector2(1500, 0)
		get_tree().get_first_node_in_group("TileMap").update_if_player_win()
