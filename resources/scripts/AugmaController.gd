extends Control

var now = Time.get_time_dict_from_system()

@onready var time_label: Label = $UIBasic/TextureRect2/Label
@onready var timer = $Timer
@onready var applications_bottom_menu: Control = $UIBasic/TextureRect/ApplicationsBottomMenu
@onready var application_on_top: Control = $ApplicationOnTop


# TEST: This is an array to keep currently running applications
var active_apps: Dictionary = {}
var current_flags: Array[String] = []

func _ready():
	timer.timeout.connect(_update_time)
	_update_time()
	

func _update_time():
	now = Time.get_time_dict_from_system()
	var text_now = "%02d:%02d" % [now["hour"], now["minute"]]
	time_label.text = text_now


func update_flags():
	for flag in current_flags:
		pass

func disable_widgets():
	var widgets = get_tree().get_nodes_in_group("widgets")
	if widgets != []:
		for widget in widgets:
			widget.visible = false

func apply_flags(flags: Array[String]):
	for flag in flags:
		if flag in current_flags:
			pass
		else:
			current_flags.append(flag)
			update_flags()

func disable_flags():
	pass

func load_app(app_path: String, flags: Array[String] = []):
	var app:PackedScene = load(app_path)
	var current: Control = app.instantiate()
	application_on_top.add_child(current)

	active_apps[app_path] = [current, flags]
	
	current.tree_exited.connect(_remove_node_from_dict.bind(app_path))


func request_load_app(app_path: String, flags: Array[String] = []):
	var apps_keys = active_apps.keys()
	print(apps_keys)

	if flags != []:
		apply_flags(flags)

	if app_path in apps_keys and apps_keys != []:
		unload_app(app_path)
	else:
		load_app(app_path, flags)

func unload_app(app_path: String):
	var loaded_app = active_apps.get(app_path)[0]
	loaded_app.queue_free()
	active_apps.erase(app_path)


func _remove_node_from_dict(key):
	if active_apps.has(key):
		active_apps.erase(key)
		
func _process(delta: float) -> void:
	var gyro_data = Input.get_gyroscope()
	position.x += (gyro_data.y * 80) * delta
	position.x = lerp(position.x, 0.0, 4.0 * delta)
