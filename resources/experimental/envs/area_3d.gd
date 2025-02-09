extends Area3D

@onready var sub_viewport: SubViewport = $"../SubViewport"

func _input_event(camera: Camera3D, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		var uv = position_to_uv(event_position)
		var viewport = sub_viewport
		var click_pos = Vector2(uv.x * viewport.size.x, uv.y * viewport.size.y)
		
		var new_event = event.duplicate()
		new_event.position = click_pos
		
		viewport.push_input(new_event)


func position_to_uv(pos: Vector3) -> Vector2:
	var mesh_instance = $"../MeshInstance3D"

	var local_pos = mesh_instance.global_transform.affine_inverse() * pos
	var quad_size = mesh_instance.mesh.size
	var uv = Vector2(
		(local_pos.x / quad_size.x) + 0.5,
		(-local_pos.y / quad_size.y) + 0.5
	)
	return uv
