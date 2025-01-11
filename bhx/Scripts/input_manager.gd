class_name InputManager
extends Node2D
@onready var clock: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var tilemap: TileManager = $"../Tilemap"
@onready var plane_script: Plane1 = $"../../Plane"
@onready var jicleur_de_terre: CPUParticles2D = $"../JicleurDeTerre"

enum SelectingType {
	NONE,
	DESTROY1,
	PLANE1,
	PLANE2,
	PLANE3
}

var selecting_type: SelectingType
func duplicate_clock(position,time,speed):
	clock.visible = false
	var new_clock = clock.duplicate()
	new_clock.visible = true
	new_clock.global_position = position
	add_child(new_clock)
	new_clock.play()
	new_clock.speed_scale = speed
	await get_tree().create_timer(time).timeout
	new_clock.queue_free()
	
	
func _ready() -> void:
	selecting_type = SelectingType.NONE

func _input(event: InputEvent) -> void:
	update_hover()
	var did_do_something: bool = false
	if Input.is_action_just_pressed("Test1"):
		selecting_type = SelectingType.DESTROY1
		get_tree().get_first_node_in_group("TileMap").update_if_player_win()

	elif Input.is_action_just_pressed("Click") and selecting_type == SelectingType.DESTROY1:
		selecting_type = SelectingType.NONE
		destroy()

	elif Input.is_action_just_pressed("Click") and selecting_type == SelectingType.PLANE1:
		duplicate_clock(get_global_mouse_position(), 11.5, 0.4)

		selecting_type = SelectingType.NONE
		var clicked_pos: Vector2 = get_clicked_tile().position
		await get_tree().create_timer(10.0).timeout
		plane_script.plane_function(tilemap.map, clicked_pos)

	elif Input.is_action_just_pressed("Click") and selecting_type == SelectingType.PLANE2:
		duplicate_clock(get_global_mouse_position(), 11.5, 0.4)
		selecting_type = SelectingType.NONE
		await get_tree().create_timer(10.0).timeout

		var clicked_position: Vector2 = get_clicked_tile().position
		var centers: Array[Vector2] = [clicked_position, clicked_position + Vector2(5, 0), clicked_position - Vector2(5, 0)]
		for center in centers:
			plane_script.plane_function(tilemap.map, center)


func get_clicked_tile() -> Tile:
	var coords: Vector2i = tilemap.ground.local_to_map(tilemap.ground.get_local_mouse_position()) + tilemap.offset
	if coords.y % 2 == 0:
		coords += Vector2i(0, 1)
	else:
		coords += Vector2i(0, 1)
	return tilemap.get_tile_from_position(tilemap.map, coords)

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
	duplicate_clock(get_global_mouse_position(), 1.2, 4.2)
	await get_tree().create_timer(1.0).timeout
	new_jicleur.emitting = false
	return new_jicleur.global_position

func destroy() -> void:
	var coords: Vector2i = tilemap.ground.local_to_map(get_global_mouse_position()) + tilemap.offset
	var t: Tile = tilemap.get_tile_from_position(tilemap.map, coords)
	if t.type == Game.TileType.FOREST and t.heat < 0.1:
		Sound.jicle()
		var position_jic = await duplicate_jicleur()
		if coords.y % 2 == 0:
			coords += Vector2i(0, 1)
		else:
			coords += Vector2i(0, 1)
		tilemap.delete_forest(coords)
		tilemap.update()
