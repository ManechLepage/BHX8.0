extends Node2D

func _ready() -> void:
	await get_tree().create_timer(30.0).timeout
	queue_free()

func _process(delta: float) -> void:
	position += Vector2(6, -3)
