extends Panel

@export var min_max_degrees: Vector2 = Vector2.ZERO

@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var central_label: Label = $Label3

var can_update: bool = false

func _ready() -> void:
	can_update = true

func set_background_color(target_color: Color):
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = target_color
	
	new_sb.corner_radius_bottom_left = 5
	new_sb.corner_radius_bottom_right = 5
	new_sb.corner_radius_top_left = 5
	new_sb.corner_radius_top_right = 5
	
	add_theme_stylebox_override("panel", new_sb)
	#var current_sb = get_theme_stylebox("panel")
	#current_sb.bg_color = target_color

func update_central_label(content: String):
	if can_update:
		central_label.text = content
	else:
		printerr("Couldn't update status. Not ready.")

func update_dg(temperature_unit: String):
	if can_update:
		label.text = "%d%s" % [min_max_degrees.x, temperature_unit]
		label_2.text = "%d%s" % [min_max_degrees.y, temperature_unit]
	else:
		printerr("Couldn't update status. Not ready.")
