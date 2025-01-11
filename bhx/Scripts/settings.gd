extends Control

@onready var menu: Control = $"../Menu"

func _on_button_pressed() -> void:
	menu._ready()
