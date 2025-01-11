extends Node
@onready var money: AudioStreamPlayer = $money
@onready var planesa: AudioStreamPlayer = $planesa
@onready var jicleur: AudioStreamPlayer = $Jicleur
@onready var planifere: AudioStreamPlayer = $planifere
@onready var music: AudioStreamPlayer = $music
@onready var thunder: AudioStreamPlayer = $thunder
func jicle() -> void:
	jicleur.play()

func plane() -> void:
	planifere.play()
	planesa.play()
func dinero() -> void:
	money.play()


func _on_music_finished() -> void:
	music.play()
func storm() -> void:
	thunder.play()
	
