extends Camera3D

const PLACEMENT_HEIGHT : float = 1
const FRUITS = [
	"blueberry",
	"strawberry",
	"grapes",
	"peach",
	"lemon",
	"plum",
	"orange",
	"apple",
	"pineapple",
	"melon",
	"watermelon"
]

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
	if event.is_action_pressed("fire"):
		self._on_fire_triggered(event)
	
	if event is InputEventMouseMotion:
		var overlay = self.get_mouse_overlay(event.position)
		if not overlay.is_empty():
			cursor.global_position = overlay.position

func _on_fire_triggered(event: InputEvent) -> void:
	var overlay = self.get_mouse_overlay(event.position)
	if overlay.is_empty(): return
	
	var fruit_name = FRUITS[randi() % 5]
	var prefab = load("res://prefabs/fruits/" + fruit_name + ".tscn")
	
	var fruit = prefab.instantiate()
	self.get_tree().get_root().add_child(fruit)
	
	fruit.add_to_group("fruits")
	fruit.global_position = Vector3(overlay.position) + Vector3.UP * PLACEMENT_HEIGHT
	
	
