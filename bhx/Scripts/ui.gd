extends Control
@onready var actions_list: VBoxContainer = $Actions_list

@export var events: Array[Event]

func _ready() -> void:
	for i in range(3):
		actions_list.get_child(i).load_event(events[i])
