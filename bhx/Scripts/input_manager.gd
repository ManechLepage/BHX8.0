extends Node2D

@onready var tilemap: TileManager = $"../Tilemap"

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
	#elif Input.is_action_just_pressed("Click") and selecting_type == SelectingType.DESTROY1:
	elif Input.is_action_just_pressed("Click"):
		destroy()
		selecting_type = SelectingType.NONE

func destroy() -> void:
	var coords: Vector2i = tilemap.ground.local_to_map(get_global_mouse_position()) + tilemap.offset - Vector2i(0, 1)
	if tilemap.get_tile_from_position(tilemap.map, coords).type == Game.TileType.FOREST:
		tilemap.delete_forest(coords)
		tilemap.update()
