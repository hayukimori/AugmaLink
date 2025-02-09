extends Button

@export_category("Application Configs")
@export var exec: String = "res://"
@export var application_name: String = "No Name"
@export var flags: Array[String]

func _ready():
	await get_tree().process_frame
	pressed.connect(call_application)

func call_application():
	var controller = get_tree().get_first_node_in_group("global_controller")
	
	if controller.has_method("request_load_app"):
		controller.request_load_app(exec, flags)
	else:
		print("First controller has no method 'request_load_app'")
