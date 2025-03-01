extends Control


enum WEngine {OpenMeteo}

@export_category("Application Flags")


@export_category("Weather Application")
@export var weather_engine: WEngine # Will not be used by now, but in the future it will be used
@export_file var sample_json
@export var sample_url: String
@export var load_fake_response: bool


@onready var current_degrees_label: Label = $BackPanel/CurrentDayPanel/CurrentDegreesLabel
@onready var maximum_degrees_label: Label = $BackPanel/CurrentDayPanel/MaximumDegreesLabel
@onready var minimum_degrees_label: Label = $BackPanel/CurrentDayPanel/MinimumDegreesLabel
@onready var sprite_animations: AnimationPlayer = $SpriteAnimations
@onready var sprite_2d: Sprite2D = $BackPanel/LeftContainers/Sprite2D
@onready var bars_container: HBoxContainer = $BackPanel/LeftContainers/horizontal_line_space/bars


@onready var horizontal_line_space: Control = $BackPanel/LeftContainers/horizontal_line_space
@onready var http_request: HTTPRequest = $HTTPRequest


var timezone: String = ""
var timeformat: String = "iso8601"
var temperature_unit: String = "ºC"


func _ready():
	sprite_2d.visible = true
	sprite_animations.play("loading")
	
	http_request.request_completed.connect(_api_rp_complete)
	
	await get_tree().process_frame
	
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
	
	timeformat = response["current_units"]["time"]
	temperature_unit = response["current_units"]["temperature_2m"]
	
	var tsp_len = len(timestamps)
	var tmp_len = len(temperatures)
	
	var rearranged_list: Array[Dictionary] = []

	if tsp_len != tmp_len:
		print("Timestamps legnth and temperatures length are different.")
		
	else:
		for i in range(tsp_len):
			rearranged_list.append(
				{ timestamps[i]: temperatures[i] }
			)

		var temp = process_listed_weather(rearranged_list, 2)
		var current_date: Dictionary = Time.get_date_dict_from_system()
		
		current_degrees_label.text = "%02d %s" % [int(response["current"]["temperature_2m"]), temperature_unit]
		
		var current_date_string: String = "%d-%02d-%02d" % \
		[current_date.year, current_date.month, current_date.day]
		
		new_baselines(temp[0], temp[1])
		#draw_baselines(temp[0], temp[1])
		set_min_max_dg(temp[1], current_date_string, maximum_degrees_label, minimum_degrees_label)
		_instantiate_panels(temp[1])


func set_min_max_dg(simple_data: Dictionary, date_string: String, label_max: Label, label_min: Label):
	var date_data = simple_data.get(date_string)
	
	var ma_dg: float = date_data.get("maximum")
	var mi_dg: float = date_data.get("minimum")
	
	label_max.text = "%d ºC" % int(ma_dg)
	label_min.text = "%d ºC" % int(mi_dg)


func new_baselines(data: Dictionary, simple_data: Dictionary):
	var current_datetime: Dictionary = Time.get_date_dict_from_system()
	var date_string = "%d-%02d-%02d" % [current_datetime.year, current_datetime.month, current_datetime.day]
	
	var date_full_data = data.get(date_string)
	var date_simple_data = simple_data.get(date_string)
	
	var min_dg = date_simple_data["minimum"]
	var max_dg = date_simple_data["maximum"]
	
	var hourly_bar_src = load("res://resources/scenes/ui/weather_app/hourly_bar.tscn")
	
	for item in date_full_data:
		var current_temp = date_full_data[item]
		var _lp = ((current_temp - min_dg)/(max_dg*1.5 - min_dg*1.5)) * 100
		
		var current_bar: ProgressBar = hourly_bar_src.instantiate()
		current_bar.custom_minimum_size.x = 19
		current_bar.value = _lp
		
		bars_container.add_child(current_bar)
		


func draw_baselines(data: Dictionary, simple_data: Dictionary):
	var current_datetime: Dictionary = Time.get_date_dict_from_system()
	var date_string = "%d-%02d-%02d" % [current_datetime.year, current_datetime.month, current_datetime.day]
	
	var date_data = data.get(date_string)
	var date_simple_data = simple_data.get(date_string)
	
	var min_dg = date_simple_data["minimum"]
	var max_dg = date_simple_data["maximum"]
	
	var sbp = horizontal_line_space.size.x / len(date_data) 
	
	var last_point_data = Vector2.ZERO
	
	var line: Line2D = Line2D.new()
	line.joint_mode = Line2D.LINE_JOINT_BEVEL
	line.width = 2
	line.antialiased = true
	line.default_color = Color.hex(0x9fe5eeb0)
	horizontal_line_space.add_child(line)
	
	for item in date_data:
		var _lp = ((date_data[item] - min_dg)/(max_dg - min_dg)) * horizontal_line_space.size.y
		
		var point_x = last_point_data.x + sbp
		var current_point = Vector2(last_point_data.x + sbp, (horizontal_line_space.size.y + 10) + (_lp * -1))
		
		
		var nlabel = Label.new()
		nlabel.text = "%sh" % item.split("T")[1].split(":")[0]
		nlabel.position = Vector2(point_x, 200)
		nlabel.scale = Vector2(0.5, 0.5)
		horizontal_line_space.add_child(nlabel)
		
		line.add_point(current_point)
		
		last_point_data = current_point


func process_listed_weather(rearranged_list:Array[Dictionary], ret_method: int = 0):
	
	# Methods
	# 0 - Return days groups (Dictionary)
	# 1 - Return days_groups_simple (Dictionary)
	# 2 - Return days_groups and days_groups_simple
	
	var days_groups: Dictionary = {}
	var days_groups_simple: Dictionary = {}
	var current_day: String = ""
	var current_group: Dictionary = {}

	for datetime in rearranged_list:
		var dt_date = datetime.keys()[0].split("T")[0]
		if dt_date != current_day:
			#print("%s != %s" % [current_day, dt_date])

			if current_group != {}:
				days_groups[current_day] = current_group

			current_day = dt_date
			current_group = {}
		elif datetime == rearranged_list[-1]:
			days_groups[current_day] = current_group

		current_group[datetime.keys()[0]] = datetime.values()[0]



	for day in days_groups:
		var schedule_temperatures = days_groups[day]
		var temperatures_list: Array = []
		
		var maximum: float = 0.0
		var minimum: float = 0.0
		
		for timestamp in schedule_temperatures:
			temperatures_list.append(schedule_temperatures[timestamp])	
		
		maximum = temperatures_list.max()
		minimum = temperatures_list.min()
		
		days_groups_simple[day] =  {"maximum": maximum, "minimum": minimum}
	
	match ret_method:
		0: return days_groups
		1: return days_groups_simple
		2: return [days_groups, days_groups_simple]
		_: return {"error": "Return method not available"}


func _instantiate_panels(simple_data: Dictionary):
	var bpd: PackedScene = load("res:///resources/scenes/ui/weather_app/basic_panel_day.tscn")
	
	for item in simple_data.keys():
		var z = $BackPanel/LeftContainers/BaseContainers/HBoxContainer
		
		var current_panel = bpd.instantiate()
		var sd_content: Dictionary = simple_data[item]
		var bg_color: Color = Color("76c1e0")
	
		current_panel.min_max_degrees = Vector2(sd_content["minimum"], sd_content["maximum"])
		current_panel.set_background_color(bg_color)
		
		z.add_child(current_panel)
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
