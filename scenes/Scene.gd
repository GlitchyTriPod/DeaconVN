class_name Scene extends Node2D

const DialogueSettings = preload("res://addons/dialogue_manager/components/settings.gd")
const DialogueUI = preload("res://dialogue/DialogueUI.tscn")

@export var startup_dialogue_resource: DialogueResource
@export var startup_dialogue_title: String = ""

@onready var cgs: Array [ Node ] = %CGs.get_children()

var ui: DialogueUI

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_node("/root/SceneManager").load_complete

	load_dialogue(self.startup_dialogue_title, self.startup_dialogue_resource)

func load_dialogue(title: String, res: Resource):
	self.ui = DialogueUI.instantiate()
	self.add_child(self.ui)

	# var dia_res : DialogueResource = load(startup_dialogue_resource.resource_path)

	await ui.ready_for_dialogue

	await get_tree().create_timer(0.3).timeout
	self.ui.start(res, title)

func get_character(char_name: String):
	for item in %CharacterContainer.get_children():
		if item.character_name.to_lower() == char_name.to_lower():
			return item

func get_character_position(pos: String) -> Vector2:
	for item in %CharacterPositions.get_children():
		if item.name.to_lower() == pos.to_lower():
			return item.position
	return Vector2(640,310)

func move_character(char_name: String, target_pos: Variant):
	var character: Character = get_character(char_name)

	var pos: Vector2
	if target_pos is String:
		pos = get_character_position(target_pos)
	else:
		pos = Vector2(target_pos.x, 310)

	character.change_position(pos)
	await character.character_moved

func display_cg(cg_name: String, fade_time: float = 0.0):
	var cg: Control
	for node in self.cgs:
		if node.name == cg_name:
			cg = node
			break

	var tween = create_tween()
	await tween.tween_property(
		cg,
		"modulate",
		Color("#ffffff"),
		fade_time
	).finished

func hide_cg(cg_name: String, fade_time: float = 0.0):
	var cg: Control
	for node in self.cgs:
		if node.name == cg_name:
			cg = node
			break

	var tween = create_tween()
	await tween.tween_property(
		cg,
		"modulate",
		Color("#ffffff00"),
		fade_time
	).finished
