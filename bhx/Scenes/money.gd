extends Panel

var money: int
@onready var money_label: Label = $Money
@onready var money_timer: Timer = $Money/Money_timer

func _ready() -> void:
	money = 100
	money_label.text = str(money)


func _on_money_timer_timeout() -> void:
	money += 1000

func _process(delta: float) -> void:
	money_label.text = str(money)
