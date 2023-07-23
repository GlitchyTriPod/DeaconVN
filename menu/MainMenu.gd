class_name MainMenu extends CanvasLayer

signal new_game

@export var new_game_dialogue: DialogueResource
@export var new_game_title: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	%Control.modulate = Color("#ffffff00")

	var tween = create_tween()
	tween.tween_property(
		%Control,
		"modulate",
		Color("#ffffff"),
		0.5
	)

func delete_self():
	var tween = create_tween()
	await tween.tween_property(
		%Control,
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
