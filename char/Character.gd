@tool
class_name Character extends Node2D

@export var character_name: String

@export var current_expression: String = "default":
	set(expression):
		if self.expressions == null:
			await self.ready

		if current_expression != expression:
			for child_exp in self.expressions.get_children():
				if child_exp.name != expression:
					child_exp.visible = false
				else:
					child_exp.visible = true
		current_expression = expression

@export_enum("left", "right") var face_direction: String = "right":
	set(direction):
		if face_direction != direction:
			change_direction()

		face_direction = direction
	get:
		return face_direction

@export_enum("left", "right") var default_face_direction: String = "right"

@export var character_label_color: Color = Color("#ffffff")

@export_enum("low", "high") var text_sound: String = "low"

@onready var expressions: Node2D = %Expressions
@onready var size_ref: Sprite2D = %Size_reference


# Called when the node enters the scene tree for the first time.
func _ready():
	self.size_ref.visible = false
	if self.face_direction != self.default_face_direction:
		change_direction(true)

func change_expression(expression: String, direction: String = self.face_direction):
	if direction != self.face_direction:
		self.face_direction = direction
		await get_tree().create_timer(0.15).timeout
	self.current_expression = expression

func change_direction(snap: bool = false):
	if self.expressions == null:
		await self.ready
		snap = true

	var tween = create_tween()
	tween.tween_property( \
			self.expressions, \
			"scale", \
			Vector2(self.expressions.scale.x * -1, self.expressions.scale.y), \
			0.0 if snap else 0.3 \
		).set_ease(Tween.EASE_IN_OUT)

func change_position(pos: Vector2):
	var tween = create_tween()
	tween.tween_property( \
		self, \
		"position", \
		pos,
		0.3 \
	).set_ease(Tween.EASE_IN_OUT)
	
## SIGNAL

