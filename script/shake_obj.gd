# Apply this script to any node that needs to be able to shake
extends Node

@export var shake_amount: float = 0.0

@export var lock_x := false
@export var lock_y := false

func _process(_delta):
	var x_lock := 1.0
	var y_lock := 1.0

	if self.lock_x:
		x_lock = 0.0
	if self.lock_y:
		y_lock = 0.0

	if "rect_position" in self:
		self.rect_position = Vector2(
			(randf_range(-20, 20) * shake_amount) * x_lock,
			(randf_range(-20, 20) * shake_amount) * y_lock
		)
		
	elif "position" in self:
		self.position = Vector2(
			(randf_range(-20, 20) * shake_amount) * x_lock,
			(randf_range(-20, 20) * shake_amount) * y_lock
		)
