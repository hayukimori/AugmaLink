extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var sub_viewport: SubViewport = $SubViewport


func _ready() -> void:
	var material = StandardMaterial3D.new()
	var vp_texture = sub_viewport.get_texture()
	
	#material.emission_enabled = true
	
	material.albedo_texture = vp_texture
	#material.emission_texture = vp_texture
	
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	#material.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.disable_receive_shadows = true
	
	mesh_instance_3d.material_override = material
