extends Control
class_name NotificationAreaController

@onready var notifications_list_vbox = $NotificationsList

var notification_base: PackedScene = preload("res://resources/scenes/ui/notification_manager/side_noitification.tscn")


func _ready() -> void:
	# self add to NotificationController.gd
	NotificationController.main_controller = self

func new_notification(application_name: String, app_icon: ImageTexture, content: String, persistent: bool = false) -> void:
	
	var notification_object: Button = notification_base.instantiate()
	
	notification_object.application_name = application_name
	notification_object.application_icon = app_icon
	notification_object.content = content
	notification_object.persistent = persistent

	notifications_list_vbox.add_child(notification_object)
