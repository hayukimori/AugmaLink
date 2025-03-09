extends Control

@onready var notifications_list_vbox = $NotificationsList

var notification_base: PackedScene = preload("res://resources/scenes/ui/notification_manager/side_noitification.tscn")

func new_notification(application_name: String, app_icon: Texture, content: String) -> void:
	print(application_name)
	print(content)
	print(app_icon)

	var notification_object: Button = notification_base.instantiate()
	
	notification_object.application_name = application_name
	notification_object.application_icon = app_icon

	notifications_list_vbox.add_child(notification_object)
