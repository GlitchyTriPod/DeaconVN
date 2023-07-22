extends Node2D

# const DialogueSettings = preload("res://addons/dialogue_manager/components/settings.gd")

# const DialogueUI = preload("res://dialogue/DialogueUI.tscn")

# @export var test_dialogue: Resource
# @export var test_dialogue_title: String = ""

@export var default_scene: String


# Called when the node enters the scene tree for the first time.
func _ready():

	RenderingServer.set_default_clear_color(Color(0,0,0))

	get_node("/root/SceneManager").load_scene(default_scene)
