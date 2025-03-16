extends Node

@export_category("User Settings Save")
@export var saving_path: String = "user://user_settings.tres"

var current_user: UserSettings = UserSettings.new()

class UserLocationData:
	var city: String = "null"
	var latitude: String = "0.0000"
	var longitude: String = "0.0000"
	var utc_offset: String = "-0000"


func register(uuid: String, display_name: String, nickname:String, img_texture: ImageTexture, accent_color: Color, local_data: UserLocationData) -> void:
	var user = UserSettings.new()

	user.uid = uuid
	user.username = nickname
	user.display_name = display_name
	user.picture = img_texture
	user.accent_color = accent_color
	
	user.isDataComplete = (local_data.city != "null")

	user.cityName = local_data.city
	user.latitude = local_data.latitude
	user.longitude = local_data.longitude
	user.utcOffset = local_data.utc_offset

	ResourceSaver.save(user, saving_path)

func userExists() -> bool:
	return FileAccess.file_exists(saving_path)

func loadDefaultUser() -> void:
	current_user = load(saving_path)

func getCurrentUser() -> UserSettings:
	return current_user
