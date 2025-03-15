extends Control

@onready var accent_color_picker: ColorPickerButton = $AccentColorPicker
@onready var done_btn: Button = $DoneBtn


func _ready() -> void:
	pass


func _on_accent_color_picker_color_changed(color: Color) -> void:
	var normal_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("normal")
	var hover_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("hover")
	var focus_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("focus")
	var pressed_stylebox: StyleBoxFlat = accent_color_picker.get_theme_stylebox("pressed")
	
	var done_btn_normal_stylebox: StyleBoxFlat = done_btn.get_theme_stylebox("normal")
	var done_btn_hover_stylebox: StyleBoxFlat = done_btn.get_theme_stylebox("hover")
	var done_btn_focus_stylebox: StyleBoxFlat = done_btn.get_theme_stylebox("focus")
	var done_btn_pressed_stylebox: StyleBoxFlat = done_btn.get_theme_stylebox("pressed")
	
	# Accent color BTN
	normal_stylebox.bg_color = color
	normal_stylebox.border_color = color

	hover_stylebox.bg_color = color
	hover_stylebox.border_color = color

	focus_stylebox.bg_color = color
	focus_stylebox.border_color = color

	pressed_stylebox.bg_color = color
	pressed_stylebox.border_color = color
	

	 # Done BTN
	done_btn_normal_stylebox.bg_color = color
	done_btn_normal_stylebox.border_color = color

	done_btn_hover_stylebox.bg_color = color
	done_btn_hover_stylebox.border_color = color

	done_btn_focus_stylebox.bg_color = color
	done_btn_focus_stylebox.border_color = color

	done_btn_pressed_stylebox.bg_color = color
	done_btn_pressed_stylebox.border_color = color


func _on_done_btn_pressed() -> void:
	pass
