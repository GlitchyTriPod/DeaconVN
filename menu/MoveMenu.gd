class_name MoveMenu extends CanvasLayer

signal exiting_menu

@export var move_button_default_texture: CompressedTexture2D

@onready var scene_button_template: MoveMenuButton = %Template
@onready var scene_container: GridContainer = %SceneContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	self.scene_button_template.hide()

	load_scene_information()

	self.get_node("Control").modulate.a = 0
	var tween = create_tween()
	tween.tween_property(
		self.get_node("Control"),
		"modulate",
		Color("#ffffffff"),
		0.4
	)

func load_scene_information():
	var sm = get_node("/root/SceneManager")

	self.exiting_menu.connect(sm.current_scene.load_dialogue)

	var scenes: Dictionary = sm.movable_scenes

	for i in scenes.size():
		if scenes.keys()[i] == sm.current_scene.scene_name:
			continue

		var dict = scenes.values()[i]

		if !dict.unlocked:
			continue

		var button = self.scene_button_template.duplicate()
		button.scene_name = scenes.keys()[i]
		if dict.img == null:
			button.texture = self.move_button_default_texture
		else:
			button.texture = dict.img

		button.text = dict.name

		button.visible = true
		button.move_button_up.connect(self._on_template_move_button_up)
		self.scene_container.add_child(button)

func exit_menu():
	get_node("/root/AudioManager").play_sfx("selectblip2")
	var tween = create_tween()
	await tween.tween_property(
		self.get_node("Control"),
		"modulate",
		Color("#ffffff00"),
		0.4
	).finished

	self.exiting_menu.emit()

	queue_free()

## SIGNAL

func _on_button_button_up():
	exit_menu()

func _on_template_move_button_up(scene_name: String):
	get_node("/root/AudioManager").play_sfx("selectblip2")
	get_node("/root/SceneManager").load_scene(scene_name)
	exit_menu()
