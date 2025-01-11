extends Control

@onready var actions_list: VBoxContainer = $Actions_list
@onready var money: Panel = $money

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

func destroy() -> void:
	input_manager.selecting_type = input_manager.SelectingType.DESTROY1

func plane() -> void:
	input_manager.selecting_type = input_manager.SelectingType.PLANE1

func plane_ultimate() -> void:
	input_manager.selecting_type = input_manager.SelectingType.PLANE2
