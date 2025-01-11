extends Control
@onready var actions_list: VBoxContainer = $Actions_list

@export var events: Array[Event]

func _ready() -> void:
	for i in range(3):
		actions_list.get_child(i).load_event(events[i])
		if i == 0:
			actions_list.get_child(i).pressed.connect(destroy)
		elif i == 1:
			actions_list.get_child(i).pressed.connect(plane)
		elif i == 2:
			actions_list.get_child(i).pressed.connect(plane_ultimate)

func destroy() -> void:
	pass

func plane() -> void:
	pass

func plane_ultimate() -> void:
	pass
