class_name DailyReport
extends Control

@export var close_button: BaseButton
@export var revenue_label: Label
@export var stars_container: Stars

func _ready() -> void:
	hide()
	close_button.pressed.connect(func(): hide())

func open(revenue: Array[int], reviews: Array[int]):
	revenue_label.text = "$%s" % revenue.reduce(func(a, b): return a + b, 0)
	stars_container.update(KfpManager.calculate_average(reviews))
	show()
