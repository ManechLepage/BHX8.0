extends Control

@onready var game: Node2D = $"../../Game"
@onready var control: Control = $"../Control"
@onready var settings: Control = $"../Settings"

func _ready() -> void:
	game.visible = false
	control.visible = false
	visible = true
	settings.visible = false


func _on_button_2_pressed() -> void:
	settings.visible = true
	visible = false
