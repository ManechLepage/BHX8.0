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
	update_hover()
	if Input.is_action_just_pressed("Test1"):
		selecting_type = SelectingType.DESTROY1
	elif Input.is_action_just_pressed("Click") and selecting_type == SelectingType.DESTROY1:
		destroy()
		selecting_type = SelectingType.NONE

func update_hover() -> void:
	for tile in tilemap.indicators.get_used_cells():
			if tilemap.indicators.get_cell_atlas_coords(tile) == Vector2i(0, 1):
				tilemap.indicators.erase_cell(tile)
	if selecting_type != SelectingType.NONE:
		tilemap.indicators.set_cell(tilemap.indicators.local_to_map(get_global_mouse_position()), 1, Vector2i(0, 1))

func duplicate_jicleur() -> Vector2:
	var new_jicleur = jicleur_de_terre.duplicate()
	new_jicleur.global_position = get_global_mouse_position()
	add_child(new_jicleur)
	new_jicleur.emitting = true
	await get_tree().create_timer(4.0).timeout
	new_jicleur.emitting = false
	return new_jicleur.global_position
	
func destroy() -> void:
	var coords: Vector2i = tilemap.ground.local_to_map(get_global_mouse_position()) + tilemap.offset
	if tilemap.get_tile_from_position(tilemap.map, coords).type == Game.TileType.FOREST:
		var position_jic = await duplicate_jicleur()
		if coords.y % 2 == 0:
			coords += Vector2i(0, 1)
		else:
			coords += Vector2i(0, 1)
		tilemap.delete_forest(coords)
		tilemap.update()
