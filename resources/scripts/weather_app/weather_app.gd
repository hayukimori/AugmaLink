extends Control


enum WEngine {OpenMeteo}

@export_category("Application Flags")


@export_category("Weather Application")
@export var weather_engine: WEngine # Will not be used by now, but in the future it will be used
@export_file var sample_json
@export_file var weather_codes_json
@export var sample_url: String
@export var load_fake_response: bool


@onready var current_degrees_label: Label = $BackPanel/CurrentDayPanel/CurrentDegreesLabel
@onready var maximum_degrees_label: Label = $BackPanel/CurrentDayPanel/MaximumDegreesLabel
@onready var minimum_degrees_label: Label = $BackPanel/CurrentDayPanel/MinimumDegreesLabel
@onready var sprite_animations: AnimationPlayer = $SpriteAnimations
@onready var sprite_2d: Sprite2D = $BackPanel/LeftContainers/Sprite2D
@onready var bars_container: HBoxContainer = $BackPanel/LeftContainers/horizontal_line_space/bars
@onready var clouds_texture_rect: TextureRect = $BackPanel/CurrentDayPanel/CloudsTextureRect

@onready var horizontal_line_space: Control = $BackPanel/LeftContainers/horizontal_line_space
@onready var http_request: HTTPRequest = $HTTPRequest



var timezone: String = ""
var timeformat: String = "iso8601"
var temperature_unit: String = "ºC"
var global_weather_codes
var days: Array = []


class DateTimeFragment:
	var timestamp: String
	var temperature: float
	var weather_code: int


class Day:
	var date: String # "2025-03-01"
	var date_fragments: Array[DateTimeFragment] = []
	var min_max: Vector2

func _ready():
	global_weather_codes = read_json_file(weather_codes_json, true)
	
	sprite_2d.visible = true
	sprite_animations.play("loading")
	
	http_request.request_completed.connect(_api_rp_complete)

	if load_fake_response != true:
		http_request.request(sample_url)
	else:
		get_data(fake_response())

func read_json_file(file_path: String, dict_format: bool = false):
	var json_as_txt = FileAccess.get_file_as_string(file_path)
	var json_as_dict = JSON.parse_string(json_as_txt)

	return json_as_dict if dict_format else json_as_txt
	

func fake_response() -> Dictionary:
	return read_json_file(sample_json, true)


func get_data(custom_response: Dictionary) -> void:
	if sprite_animations.is_playing():
		sprite_animations.stop()
		sprite_2d.visible = false

	var response = custom_response
	var timestamps = response["hourly"]["time"]
	var temperatures = response["hourly"]["temperature_2m"]
	var list_weather_codes: Array = response["hourly"]["weather_code"]
	
	timeformat = response["current_units"]["time"]
	temperature_unit = response["current_units"]["temperature_2m"]


	var temp2: Array[Day] = new_process_weather_data(timestamps, temperatures, list_weather_codes)


	var current_date: Dictionary = Time.get_date_dict_from_system()
	current_degrees_label.text = "%02d %s" % [int(response["current"]["temperature_2m"]), temperature_unit]
		
	var current_date_string: String = "%d-%02d-%02d" % \
		[current_date.year, current_date.month, current_date.day]
		
	create_baselines(temp2)
	set_min_max_dg(temp2, current_date_string, maximum_degrees_label, minimum_degrees_label)
	_instantiate_panels(temp2)


func set_min_max_dg(data: Array[Day], date_string: String, label_max: Label, label_min: Label):
	
	var date_data: Day = match_date(data, date_string)
	
	var mi_dg: float = date_data.min_max.x
	var ma_dg: float = date_data.min_max.y
	
	label_max.text = "%d %s" % [int(ma_dg), temperature_unit]
	label_min.text = "%d %s" % [int(mi_dg), temperature_unit]


func match_date(dates: Array[Day], date_string: String) -> Day:
	var found: Day
	
	for x in dates:
		if x.date == date_string:
			found = x
			
	return found

func create_baselines(dates: Array[Day]):
	var current_datetime: Dictionary = Time.get_date_dict_from_system()
	var date_string = "%d-%02d-%02d" % [current_datetime.year, current_datetime.month, current_datetime.day]
	
	var date_data = match_date(dates, date_string)
	
	var min_dg = date_data.min_max.x
	var max_dg = date_data.min_max.y
	
	var hourly_bar_src = load("res://resources/scenes/ui/weather_app/hourly_bar.tscn")
	
	for fragment in date_data.date_fragments:
		var frag: DateTimeFragment = fragment
		var _lp = ((frag.temperature - min_dg)/(max_dg*1.5 - min_dg*1.5)) * 100

		
		var current_bar: ProgressBar = hourly_bar_src.instantiate()
		current_bar.custom_minimum_size.x = 19
		current_bar.value = _lp
		
		bars_container.add_child(current_bar)


func search_code(code: int) -> Dictionary:
	if global_weather_codes:
		if global_weather_codes.has(str(code)):
			return global_weather_codes[str(code)]
	return {}

func new_process_weather_data(timestamps: Array, temperatures: Array, weather_codes: Array) -> Array[Day]:
	var days_dict: Dictionary = {}
	
	for i in range(len(timestamps)):
		# Extract date
		var full_timestamp: String = timestamps[i]
		var date: String = full_timestamp.substr(0, 10)
		
		# Create fragment
		var fragment = DateTimeFragment.new()
		fragment.timestamp = full_timestamp
		fragment.temperature = temperatures[i]
		fragment.weather_code = weather_codes[i]

		# Add to days_dict
		if (date in days_dict.keys()) == false:
			days_dict[date] = Day.new()
			days_dict[date].date = date
		
		days_dict[date].date_fragments.append(fragment)
	
	# Calculate min/max for every day
	for day in days_dict.values():
		day.min_max = _calculate_min_max(day.date_fragments)
	
		days.append(day)
	
	var days_array: Array[Day] = []
	for y in days_dict.values():
		days_array.append(y)
		
	return days_array

func _calculate_min_max(fragments: Array[DateTimeFragment]) -> Vector2:
	var min_temp: float = INF
	var max_temp: float = INF
	
	var temps_array: Array = []
	
	for fragment in fragments:
		temps_array.append(fragment.temperature)
	
	min_temp = temps_array.min()
	max_temp = temps_array.max()
	
	return Vector2(min_temp, max_temp)

func get_frequent(numbers: Array) -> int:
	var counts = {}
	var most_frequent_num = null
	var max_count = 0
	
	for num in numbers:
		if counts.has(num):
			counts[num] += 1
		else:
			counts[num] = 1
	
	for i in counts:
		if counts[i] > max_count:
			most_frequent_num = i
			max_count = counts[i]

	return most_frequent_num


func _instantiate_panels(data: Array[Day]):
	var bpd: PackedScene = load("res:///resources/scenes/ui/weather_app/basic_panel_day.tscn")
	
	for day in data:
		var z = $BackPanel/LeftContainers/BaseContainers/HBoxContainer
		
		var current_panel = bpd.instantiate()
		var bg_color: Color = Color("76c1e0")
	
		current_panel.min_max_degrees = day.min_max
		current_panel.set_background_color(bg_color)
		
		var codes: Array = []
		
		for frag in day.date_fragments:
			codes.append(frag.weather_code)
		
		var dom: int = get_frequent(codes)
		var code_tranlation: Dictionary = search_code(dom)
		
		
		z.add_child(current_panel)
		current_panel.update_central_label(code_tranlation["day"]["description"])
		current_panel.update_dg(temperature_unit)


func _api_rp_complete(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray):
	if result == HTTPRequest.RESULT_SUCCESS:
		if response_code == 200:
			var response = body.get_string_from_utf8()
			var response_as_dict = JSON.parse_string(response)
			get_data(response_as_dict)
		else:
			print("Error. Code: ", response_code)
	else:
		print("Fail. Rest: ", result)


func _on_quit_btn_pressed() -> void:
	queue_free()


func _process(delta: float):
	var clouds_noise: NoiseTexture2D = clouds_texture_rect.texture
	var noise: FastNoiseLite = clouds_noise.noise
	
	noise.offset.x += 50 * delta
