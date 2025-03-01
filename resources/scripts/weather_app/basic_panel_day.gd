extends Panel

@export var min_max_degrees: Vector2 = Vector2.ZERO

@onready var label: Label = $Label
@onready var label_2: Label = $Label2

var can_update: bool = false

func _ready() -> void:
	can_update = true

func update_dg(temperature_unit: String):
	if can_update:
		label.text = "%d%s" % [min_max_degrees.x, temperature_unit]
		label_2.text = "%d%s" % [min_max_degrees.y, temperature_unit]
	else:
		printerr("Couldn't update status. Not ready.")
