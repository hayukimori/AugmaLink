extends Button

@export var application_name: String
@export var application_icon: ImageTexture
@export var content: String
@export var persistent: bool = false

@onready var left_icon_btn: Button = $Icon


func _ready() -> void:
	text = content
	
	if application_icon != null:
		left_icon_btn.icon = application_icon

	if not persistent:
		# Auto release
		await get_tree().create_timer(2).timeout
		queue_free()
