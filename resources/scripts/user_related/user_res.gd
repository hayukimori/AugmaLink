extends Resource
class_name UserSettings

@export_category("Basic data")
@export var uid: String
@export var username: String
@export var display_name: String
@export var picture: ImageTexture
@export var accent_color: Color

@export_category("User LAT_ALT")
@export var latitude: String
@export var altitude: String
@export var cityName: String
@export var GMT: int
