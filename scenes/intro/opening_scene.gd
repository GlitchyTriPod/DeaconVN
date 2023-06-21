extends Scene

const MainMenu = preload("res://menu/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	await super()
	self.ui.connect("dialogue_exiting", load_main_menu)

func load_main_menu():
	var menu = MainMenu.instantiate()
	self.add_child(menu)
