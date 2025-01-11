extends Node
@onready var planesa: AudioStreamPlayer = $planesa
@onready var jicleur: AudioStreamPlayer = $Jicleur
@onready var planifere: AudioStreamPlayer = $planifere
func jicle() -> void:
	jicleur.play()

func plane() -> void:
	planifere.play()
	planesa.play()
