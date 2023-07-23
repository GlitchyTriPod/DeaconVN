class_name MoveMenuButton extends VBoxContainer

signal move_button_up(scene_name: String)

@onready var button: Button = get_node("Button")

var texture: CompressedTexture2D
var text: String
var scene_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TextureRect").texture = self.texture
	self.button.text = self.text

	self.button.button_up.connect(self.button_clicked)

func button_clicked():
	self.move_button_up.emit(self.scene_name)

