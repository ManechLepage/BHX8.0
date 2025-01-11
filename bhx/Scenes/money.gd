extends Panel

var money: int
@onready var money_label: Label = $Money
@onready var money_timer: Timer = $Money/Money_timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	money = 100
	money_label.text = str(money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_money_timer_timeout() -> void:
	money += 100
	money_label.text = str(money)
	print("+100")
