class_name TileManager
extends Node2D



var dimensions: Vector2 = Vector2(32, 32)
var seed: int = randi_range(0, 100000000000000)
var map: Array[Array] = []

func _ready() -> void:
	map = generate(seed)

func generate(seed) -> Array[Array]:
	var generated_map: Array[Array] = []
	
	for y in range(dimensions[1]):
		generated_map.append([])
		for x in range(dimensions[0]):
			generated_map[-1].append(0)
	
	return generated_map
