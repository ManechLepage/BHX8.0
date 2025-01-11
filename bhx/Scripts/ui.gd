extends Control

@onready var actions_list: VBoxContainer = $Actions_list
@onready var money: Panel = $money
@onready var wind: TextureRect = $Wind
@onready var score: Panel = $Score

@export var events: Array[Event]
var input_manager: InputManager

func _ready() -> void:
	input_manager = get_tree().get_first_node_in_group("InputManager")
	for i in range(3):
		actions_list.get_child(i).load_event(events[i])
		if i == 0:
			actions_list.get_child(i).pressed.connect(destroy)
		elif i == 1:
			actions_list.get_child(i).pressed.connect(plane)
		elif i == 2:
			actions_list.get_child(i).pressed.connect(plane_ultimate)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"):
		destroy()
		animate_score()
	elif Input.is_action_just_pressed("2"):
		plane()
	elif Input.is_action_just_pressed("3"):
		plane_ultimate()

func destroy() -> void:
	if money.money - events[0].cost >= 0:
		money.money -= events[0].cost
		input_manager.selecting_type = input_manager.SelectingType.DESTROY1

func plane() -> void:
	if money.money - events[1].cost >= 0:
		money.money -= events[1].cost
		input_manager.selecting_type = input_manager.SelectingType.PLANE1

func plane_ultimate() -> void:
	if money.money - events[2].cost >= 0:
		money.money -= events[2].cost
		input_manager.selecting_type = input_manager.SelectingType.PLANE2

func _process(delta: float) -> void:
	wind.rotation = Gamemanager.wind_orientation

func animate_score() -> void:
	score.scale = Vector2.ZERO
	var tween_scale = create_tween()
	tween_scale.tween_property(score, "scale", Vector2(1, 1), 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	var tweeen_rotation = create_tween()
	tweeen_rotation.tween_property(score, "rotation", 30 * PI, 0.2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BOUNCE)
