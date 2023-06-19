extends Node2D

# const DialogueSettings = preload("res://addons/dialogue_manager/components/settings.gd")

# const DialogueUI = preload("res://dialogue/DialogueUI.tscn")

# @export var test_dialogue: Resource
# @export var test_dialogue_title: String = ""

@export var default_scene: String


# Called when the node enters the scene tree for the first time.
func _ready():
	# var ui = DialogueUI.instantiate()
	# self.add_child(ui)

	# var dia_res : DialogueResource = load(test_dialogue.resource_path)

	# await ui.ready_for_dialogue

	# await get_tree().create_timer(0.3).timeout

	# ui.start(dia_res, test_dialogue_title)

	get_node("/root/SceneManager").load_scene(default_scene)
	# self.add_child(scn)

	pass # Replace with function body.
