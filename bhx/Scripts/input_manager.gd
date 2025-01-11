class_name InputManager
extends Node2D

@onready var tilemap: TileManager = $"../Tilemap"
@onready var jicleur_de_terre: CPUParticles2D = $"../JicleurDeTerre"

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

func destroy() -> void:
	jicleur_de_terre.global_position = tilemap.ground.get_local_mouse_position()
	jicleur_de_terre.emitting = true
	await get_tree().create_timer(4.0).timeout
	jicleur_de_terre.emitting = false
	var coords: Vector2i = tilemap.ground.local_to_map(tilemap.ground.get_local_mouse_position()) + tilemap.offset
	if coords.y % 2 == 0:
		coords += Vector2i(0, 1)
	else:
		coords += Vector2i(0, 1)
	if tilemap.get_tile_from_position(tilemap.map, coords).type == Game.TileType.FOREST:
		tilemap.delete_forest(coords)
		tilemap.update()
