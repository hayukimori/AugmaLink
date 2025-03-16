extends Node

#@export var uri = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
@export_category("Activation")
@export var active: bool = false


@export_category("Geographical")
@export var latitude: String
@export var longitude: String


@onready var temperature_label: Label = $"../OuterPanel/InnerPanel/TemperatureLabel"
@onready var city_name_label: Label = $"../OuterPanel/InnerPanel/CityNameLabel"

@onready var weather_widget: Control = $".."
@onready var http_request_node = $HTTPRequest
@onready var user_update_timer: Timer = $UserUpdateTimer

var current_response:String

func _ready():
	reload_user()

func reload_user() -> void:
	print("Reloading user....")
	var userData: UserSettings = UserSettingsManager.getCurrentUser()
	if userData.isDataComplete:
		latitude = userData.latitude
		longitude = userData.longitude
		city_name_label.text = userData.cityName

		get_weather()
	
	else:
		city_name_label.text = "No City (config)"


func update_weather_widget_content():
	var server_response:String = fake_response() if current_response == "" else current_response
	var dict_response = JSON.parse_string(server_response)
	
	#print(dict_response["temperature_2m"])
	var degrees_type: String = dict_response["current_units"]["temperature_2m"]
	var degrees_local: String = str(int(dict_response["current"]["temperature_2m"]))
	
	temperature_label.text = degrees_local + degrees_type

func get_weather():
	if active == false:
		current_response = fake_response()
		return

	var new_url = "https://api.open-meteo.com/v1/forecast?latitude="+latitude+"&longitude="+longitude+"&current="+"temperature_2m"
	var headers = [
		"Content-Type: application/json",
		"Accept:	text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
		"Accept-Encoding:	gzip, deflate, br, zstd",
		"Accept-Language:	en-US,en;q=0.5",
		"User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:134.0) Gecko/20100101 Firefox/134.0"
	]
	print("initializing request")
	http_request_node.request(new_url, headers)
	#print("request done")

func fake_response() -> String:
	var string = """
	{"latitude":-15.625,"longitude":-48.125,"generationtime_ms":0.010251998901367188,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":1228.0,"current_units":{"time":"iso8601","interval":"seconds","temperature_2m":"°C"},"current":{"time":"2025-01-30T03:00","interval":900,"temperature_2m":20.0}}
	"""
	return string


func _on_http_request_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	print("request complete.")
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			var response = body.get_string_from_utf8()
			current_response = response
		else:
			print("Error. Code: ", response_code)
	else:
		print("Fail. Rest: ", result)
	update_weather_widget_content()


func _on_user_update_timer_timeout() -> void:
	reload_user()
