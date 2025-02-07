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

var current_fruit: RigidBody3D

func _ready() -> void:
	self.current_fruit = self.select_fruit()

func select_fruit() -> RigidBody3D:
	var fruit_name = FRUITS[randi() % 5]
	var prefab = load("res://prefabs/fruits/" + fruit_name + ".tscn")
	var fruit = prefab.instantiate()
	
	self.get_tree().get_root().add_child(fruit)
	
	return fruit

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
		
		print(self.current_fruit.global_position)
		
		if not overlay.is_empty():
			cursor.global_position = overlay.position
			self.current_fruit.global_position = overlay.position

func _on_fire_triggered(event: InputEvent) -> void:
	var overlay = self.get_mouse_overlay(event.position)
	if overlay.is_empty(): return
	
	var fruit = self.select_fruit()
	
	fruit.add_to_group("fruits")
	fruit.global_position = Vector3(overlay.position) + Vector3.UP * PLACEMENT_HEIGHT
	
func _process(delta: float) -> void:
	$Control/Points.text = str(Global.points)

func _on_area_3d_body_entered(body: Node3D) -> void:
	Global.losses += 1

	if Global.losses >= 3:
		Global.points = 0
		Global.losses = 0
		
		for fruit in get_tree().get_nodes_in_group("fruits"):
			fruit.queue_free()
	
	$Control/Losses.text = str(Global.losses)
