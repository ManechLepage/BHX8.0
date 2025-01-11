extends Panel

var money: int
@onready var money_label: Label = $Money
@onready var money_timer: Timer = $Money/Money_timer

var dont_change: bool

func _ready() -> void:
	money = 100
	money_label.text = str(money)


func _on_money_timer_timeout() -> void:
	money_label.text = "+500"
	money += 500
	Sound.dinero()
	dont_change = true
	await get_tree().create_timer(0.55).timeout
	dont_change = false

func _process(delta: float) -> void:
	if not dont_change:
		money_label.text = str(money)
