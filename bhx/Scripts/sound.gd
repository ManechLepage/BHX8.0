extends Node
@onready var jicleur: AudioStreamPlayer = $Jicleur

func jicle() -> void:
	jicleur.play()
