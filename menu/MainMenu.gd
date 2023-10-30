class_name MainMenu extends CanvasLayer

signal new_game

const OptionsMenu = preload("res://menu/OptionsMenu.tscn")

@export var new_game_dialogue: DialogueResource
@export var new_game_title: String = ""

@onready var control: Control = %Control
@onready var new_game_button: Button = %NewGame
@onready var options_button: Button = %Options

# Called when the node enters the scene tree for the first time.
func _ready():
	%Control.modulate = Color("#ffffff00")

	var tween = create_tween()
	tween.tween_property(
		self.control,
		"modulate",
		Color("#ffffff"),
		0.5
	)

func delete_self():
	var tween = create_tween()
	await tween.tween_property(
		self.control,
		"modulate",
		Color("#ffffff00"),
		0.5
	).finished

	new_game.emit()

	queue_free()

func _on_new_game_button_up():
	get_node("/root/AudioManager").play_sfx("selectblip2")

	get_node("/root/SceneManager").load_dialogue(self.new_game_title, self.new_game_dialogue)

	delete_self()

func _on_options_button_up():
	get_node("/root/AudioManager").play_sfx("selectblip2")

	# remove focus from all elements on the main menu
	self.control.grab_focus()
	self.control.release_focus()

	# spawn options screen (this SHOULD block all interaction with the main menu)
	var options_menu = OptionsMenu.instantiate()

	# options_menu.get_node("Control/color").self_modulate = Color("#ffffff00")
	options_menu.get_node("Control").modulate = Color("#ffffff00")

	# OPTIoNALLY disable all buttons
	# connect exit signal to function that restores interactivity with buttons
	self.new_game_button.disabled = true
	self.options_button.disabled = true

	options_menu.connect("tree_exiting", func():
		self.new_game_button.disabled = false
		self.options_button.disabled = false

		var tween = create_tween()
		tween.tween_property( \
		get_node("Control/overlay"), \
		"modulate", \
		Color("#ffffff00"), \
		0.5 \
		)
	)

	var tween = create_tween()
	tween.tween_property( \
		get_node("Control/overlay"), \
		"modulate", \
		Color("#ffffffff"), \
		0.5 \
	)

	self.add_child(options_menu)
