extends Resource
class_name UserSettings

@export_category("Basic data")
@export var uid: String
@export var username: String
@export var display_name: String
@export var picture_path: String
@export var accent_color: Color

@export_category("User LOCALE")
@export var isDataComplete: bool
@export var latitude: String
@export var longitude: String
@export var cityName: String
@export var utcOffset: String
