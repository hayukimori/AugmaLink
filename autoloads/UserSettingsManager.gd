extends Node

@export_category("User Settings Save")
@export var saving_path: String = "user://user_settings.tres"


func register(uuid: String, display_name: String, nickname:String, img_texture: ImageTexture, accent_color: Color, latitude: String, longitude: String, GMT: int) -> void:
	var user = UserSettings.new()

	user.uid = uuid
	user.username = nickname
	user.display_name = display_name
	user.picture = img_texture
	user.accent_color = accent_color

	#var location = get_user_location()
	#user.latitude = current_latitude
	#user.longitude = current_longitude

	#ResourceSaver.save(user, saving_path)

	print(uuid)
	print(nickname)
	print(display_name)
	print(img_texture)
	print(accent_color)
	print(latitude)
	print(longitude)
	print(GMT)
