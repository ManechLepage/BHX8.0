extends Node2D

@onready var tilemap: TileManager = $"../Tilemap"
@onready var plane_script: Plane1 =$"../Plane"

enum SelectingType {
	NONE,
	DESTROY1,
	PLANE1,
	PLANE2,
	PLANE3
}

var selecting_type: SelectingType

func _ready() -> void:
	selecting_type = SelectingType.NONE

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Test1"):
		selecting_type = SelectingType.DESTROY1
	elif Input.is_action_just_pressed("Click") and selecting_type == SelectingType.DESTROY1:
		destroy()
		selecting_type = SelectingType.NONE
	elif Input.is_action_just_pressed("Click") and selecting_type == SelectingType.PLANE1:
		plane_script.plane_function(tilemap.map, get_clicked_tile().position)
		selecting_type = SelectingType.NONE

func get_clicked_tile() -> Tile:
	var coords: Vector2i = tilemap.ground.local_to_map(tilemap.ground.get_local_mouse_position()) + tilemap.offset
	if coords.y % 2 == 0:
		coords += Vector2i(0, 1)
	else:
		coords += Vector2i(0, 1)
	return tilemap.get_tile_from_position(tilemap.map, coords)

func destroy() -> void:
	var coords: Vector2i = tilemap.ground.local_to_map(tilemap.ground.get_local_mouse_position()) + tilemap.offset
	if coords.y % 2 == 0:
		coords += Vector2i(0, 1)
	else:
		coords += Vector2i(0, 1)
	if tilemap.get_tile_from_position(tilemap.map, coords).type == Game.TileType.FOREST:
		tilemap.delete_forest(coords)
		tilemap.update()
