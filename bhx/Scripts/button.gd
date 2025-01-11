extends Button

@onready var image: TextureRect = $Icon
@onready var name_label: Label = $Name
@onready var price: Label = $Price
@onready var time: Label = $Time

var event: Event

func load_event(_event: Event) -> void:
	event = _event
	image.texture = event.sprite
	name_label.text = event.name
	price.text = str(event.cost)
	time.text = str(event.duration)
