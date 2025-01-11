extends Control

@onready var game: Node2D = $"../../Game"
@onready var control: Control = $"../Control"

func _ready() -> void:
	game.visible = false
	control.visible = false
	visible = true
