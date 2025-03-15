extends Control

@onready var accent_color_picker: ColorPickerButton = $AccentColorPicker


func _ready() -> void:
	pass


func _on_accent_color_picker_color_changed(color: Color) -> void:
	var normal_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("normal")
	var hover_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("hover")
	var focus_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("focus")
	var pressed_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("pressed")
	
	normal_stylebox.bg_color = color
	normal_stylebox.border_color = color

	hover_stylebox.bg_color = color
	hover_stylebox.border_color = color

	focus_stylebox.bg_color = color
	focus_stylebox.border_color = color

	pressed_stylebox.bg_color = color
	pressed_stylebox.border_color = color
