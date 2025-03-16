extends Node

@export_category("User Settings Save")
@export var saving_path: String = "user://user_settings.tres"

class UserLocationData:
	var city: String = "null"
	var latitude: String = "0.0000"
	var longitude: String = "0.0000"
	var utc_offset: String = "-0000"


func register(uuid: String, display_name: String, nickname:String, img_texture: ImageTexture, accent_color: Color, user_local_data: UserLocationData) -> void:
	var user = UserSettings.new()

	user.uid = uuid
	user.username = nickname
	user.display_name = display_name
	user.picture = img_texture
	user.accent_color = accent_color


	#ResourceSaver.save(user, saving_path)

	print(uuid)
	print(nickname)
	print(display_name)
	print(img_texture)
	print(accent_color)
	print(user_local_data)
