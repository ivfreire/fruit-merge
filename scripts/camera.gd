extends Camera3D

@export var cursor: Node3D

func get_mouse_overlay(screen_position: Vector2):
	var space = self.get_world_3d().direct_space_state
	var start = self.project_ray_origin(screen_position)
	var end = self.project_position(screen_position, 1000)

	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	
	return space.intersect_ray(params)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var overlay = get_mouse_overlay(event.position)
		if not overlay.is_empty():
			cursor.global_position = overlay.position
		
	if event is InputEventMouseButton:
		
