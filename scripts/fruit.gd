extends RigidBody3D

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

@export var level: int = 0

var created_at : float

func _ready() -> void:
	self.contact_monitor = true
	self.max_contacts_reported = 10
	self.created_at = Time.get_ticks_msec()
	self.linear_damp = 0.1
	self.add_to_group("fruits")

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("fruits"):
		if self.level == body.level:
			if self.created_at > body.created_at:
				var path = "res://prefabs/fruits/" + FRUITS[self.level + 1] + ".tscn"
				var fruit = load(path).instantiate()
				
				fruit.global_position = (self.global_position + body.global_position) / 2
				
				self.get_tree().get_root().add_child(fruit)
			
			self.queue_free()
			body.queue_free()

func set_level(level: int) -> void:
	self.level = level
