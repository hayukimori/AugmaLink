extends Control

@export var message_text: String = "Test message"
@onready var label: Label = $Label

func change_current_size() -> void:
	custom_minimum_size.y = label.size.y + 18

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = message_text
	
	await get_tree().process_frame
	await get_tree().process_frame
	change_current_size()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
