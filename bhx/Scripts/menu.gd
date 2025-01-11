extends Control

@onready var game: Node2D = $"../../Game"
@onready var control: Control = $"../Control"
@onready var settings: Control = $"../Settings"
@onready var background: Node2D = $"../../Background"
@onready var title: TextureRect = $Title

func _ready() -> void:
	background.visible = true
	get_tree().paused = true
	game.visible = false
	control.visible = false
	visible = true
	settings.visible = false
	while true:
		var tween = create_tween()
		tween.tween_property(title, "scale", Vector2(4.7, 4.7), 0.6).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		var tween2 = create_tween()
		tween2.tween_property(title, "scale", Vector2(4.0, 4.0), 0.6).set_ease(Tween.EASE_IN_OUT)
		await tween2.finished
		if not visible:
			break



func _on_button_2_pressed() -> void:
	settings.visible = true
	visible = false


func _on_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	background.visible = false
	game.visible = true
	control.visible = true
