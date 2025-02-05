extends RigidBody3D

const FRUITS = {
	0: "Blueberry",
	1: "Strawberry",
	2: "Grapes",
	3: "Peach",
	4: "Lemon",
	5: "Plum",
	6: "Orange",
	7: "Apple",
	8: "Pineapple",
	9: "Melon",
	10: "Watermelon"
}

@export var level: int = 0

var created_at : float

func _ready() -> void:
	self.contact_monitor = true
	self.max_contacts_reported = 1
	self.created_at = Time.get_ticks_msec()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("fruits"):
		if self.level == body.level:
			if self.created_at > body.created_at:
				var fruit = load("res://prefabs/fruit.tscn").instantiate()
				
				fruit.set_level(self.level + 1)
				fruit.add_to_group("fruits")
				fruit.global_position = (self.global_position + body.global_position) / 2
				self.get_tree().get_root().add_child(fruit)
				
			self.queue_free()
			body.queue_free()

func set_level(level: int) -> void:
	self.level = level

	self.get_tree().get_root().get_child()
