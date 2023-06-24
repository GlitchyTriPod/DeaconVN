class_name MoveMenuButton extends VBoxContainer

var texture: CompressedTexture2D
var text: String
var scene_name: String

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("TextureRect").texture = self.texture
	get_node("Button").text = self.text

