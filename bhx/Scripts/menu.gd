extends Control

@onready var game: Node2D = $"../../Game"
@onready var control: Control = $"../Control"
@onready var settings: Control = $"../Settings"
@onready var background: Node2D = $"../../Background"

func _ready() -> void:
	background.visible = true
	get_tree().paused = true
	game.visible = false
	control.visible = false
	visible = true
	settings.visible = false


func _on_button_2_pressed() -> void:
	settings.visible = true
	visible = false


func _on_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	background.visible = false
	game.visible = true
	control.visible = true
	Sound.storm()
