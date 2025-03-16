extends Control

# User LE
@onready var display_name_line_edit: LineEdit = $DisplayNameLineEdit
@onready var nickname_line_edit: LineEdit = $NickNameLineEdit
@onready var user_picture_texture_rounded: TextureRectRounded = $UserPictureTextureRounded

# Buttons
@onready var accent_color_picker: ColorPickerButton = $AccentColorPicker
@onready var done_btn: Button = $DoneBtn
@onready var uuid_left_bar_label = $UUIDLeftBarLabel

# Labels
@onready var location_label: Label = $LocationLabel

@export var current_image_path: String = ""
@export var current_image_texture: ImageTexture = ImageTexture.new()



var current_color: Color
var uld: UserSettingsManager.UserLocationData = UserSettingsManager.UserLocationData.new()

func _ready() -> void:
	get_user_location()
	current_color = accent_color_picker.color


func register_user() -> void:
	var nickname_data: String = nickname_line_edit.text
	var display_name_data: String = display_name_line_edit.text

	var null_nick_dn = (nickname_data == "" or display_name_data == "")

	if null_nick_dn:
		$ErrorLabel.text = "Error: Null nickname or display name"
		return
	
	UserSettingsManager.register(
		"NOUUID",
		display_name_data, nickname_data, 
		current_image_texture, 
		accent_color_picker.color, 
		uld
	)


func update_config_image(img_path: String) -> void:
	var img: Image = Image.load_from_file(img_path)
	var txt = ImageTexture.create_from_image(img)

	user_picture_texture_rounded.texture = txt


func _on_accent_color_picker_color_changed(color: Color) -> void:
	current_color = color
	
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
	register_user()


func _on_open_file_picture_pressed() -> void:
	var dialog = FileDialog.new()
	dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
	dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.root_subfolder = "/storage/emulated/0"
	dialog.set_use_native_dialog(true)
	dialog.connect("file_selected", _on_file_selected)
	add_child(dialog)
	dialog.popup_centered_ratio()


func _on_file_selected(path: String) -> void:
	if path.ends_with(".jpg") or path.ends_with(".png"):
		current_image_path = path
	
	update_config_image(current_image_path)



func get_user_location():
	var url = "https://ipapi.co/json/"
	var http_request = HTTPRequest.new()
	add_child(http_request)
	
	http_request.connect("request_completed", _on_request_completed)
	http_request.request(url)


func _on_request_completed(result, response_code, _headers, body):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			var response = body.get_string_from_utf8()
			var json_response = JSON.parse_string(response)
	
			if json_response == null:
				print("Error getting location")

			
			uld.city = json_response["city"]
			uld.latitude = str(json_response["latitude"])
			uld.longitude = str(json_response["longitude"])
			uld.utc_offset = str(json_response["utc_offset"])

			location_label.text = "%s, %s" % [
				json_response["city"], 
				json_response["region_code"]
			]


		else:
			print("Error code: ", response_code)
	else:
		print("Fail. Rest: ", response_code)
