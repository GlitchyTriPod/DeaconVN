extends Node

signal load_complete

@export var scenes: Dictionary

var current_scene: Scene

## Scene Manipulation

func get_scene(scene_name: String):
	return self.scenes.get(scene_name).instantiate()

func load_scene(scene_name: String):
	var scn = get_scene(scene_name)
	var main = get_node("/root/Main")

	var tween = create_tween()
	
	await tween.tween_property(
		main.get_node("Overlay"),
		"color",
		Color("#000000ff"),
		.7
	).finished

	if self.current_scene != null:
		self.current_scene.queue_free()

	main.add_child(scn)
	self.current_scene = scn

	await get_tree().create_timer(0.3).timeout

	tween = create_tween()
	await tween.tween_property(
		main.get_node("Overlay"),
		"color",
		Color("#00000000"),
		.7
	).finished

	emit_signal("load_complete")

func display_cg(cg_name: String, fade_time: float = 0.0):
	self.current_scene.display_cg(cg_name, fade_time)

func hide_cg(cg_name: String, fade_time: float = 0.0):
	self.current_scene.hide_cg(cg_name, fade_time)

# Dialogue manipulation


# Character manipulation

func enter_character(
		char_name: String, \
		facing: String, \
		expression: String = "default", \
		position: Variant = "Center", \
		enter_from: String = "fade", \
	):
	var character: Character = get_node("/root/CharacterManager").get_character(char_name)

	character.face_direction = facing.to_lower()
	character.current_expression = expression.to_lower()

	match enter_from:
		"fade":
			character.modulate.a = 0
		"left":
			character.position = self.current_scene.get_character_position("OffscreenLeft")
		"right":
			character.position = self.current_scene.get_character_position("OffscreenRight")
		"top":
			if position is String:
				character.position = self.current_scene.get_character_position(position)
				character.position.y = -250.0
			else:
				character.position = Vector2(position, -250.0)

	self.current_scene.get_node("CharacterContainer").add_child(character)

	var screen_pos: Vector2
	if position is String:
		screen_pos = self.current_scene.get_character_position(position)
	else:
		screen_pos = Vector2(position, 310.0)

	if enter_from.to_lower() == "fade":
		character.position = screen_pos

		var tween = create_tween()
		await tween.tween_property(
			character,
			"modulate",
			Color("#ffffffff"),
			0.3).finished

	# character.change_position(screen_pos)
	move_character(char_name, screen_pos)

func exit_character(char_name: String, exit_side: String = "fade"):
	var character = self.current_scene.get_character(char_name)
	if exit_side == "fade":
		var tween = create_tween()
		await tween.tween_property(character, "modulate", Color("#ffffff00"), 0.3).finished
		character.queue_free()
		return

	if exit_side.to_lower() == "left" || exit_side.to_lower() == "right":
		exit_side = "offscreen" + exit_side

	move_character(char_name, exit_side)
	await character.character_moved
	character.queue_free()

func change_expression(char_name: String, expression: String = "default", facing: String = "na"):	
	var character: Character = self.current_scene.get_character(char_name)

	if facing =="na":
		character.change_expression(expression)
	else:
		character.change_expression(expression, facing)

func move_character(char_name: String, position: Variant):
	self.current_scene.move_character(char_name, position)
	
