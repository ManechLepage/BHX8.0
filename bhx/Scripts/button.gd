extends Button

@export var item_name: String
@export var item_price: int
@export var item_time: int
@export var Item_image: Texture2D

@onready var image: TextureRect = $Icon
@onready var name_label: Label = $Name
@onready var price: Label = $Price
@onready var time: Label = $Time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	image.texture = Item_image
	name_label.text = item_name
	price.text = str(item_price)
	time.text = str(item_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
