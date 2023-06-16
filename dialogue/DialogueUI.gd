class_name DialogueUI extends CanvasLayer

@onready var character_name: RichTextLabel = %Name
@onready var dialogue_label = %DialogueLabel
@onready var response_box = %ResponseBox
@onready var response_template: Button = %ResponseTemplate

# the diaglogue resource
var dialogue_res: DialogueResource

# temporary game state
var temporary_game_states: Array = []

# prevents dialogue from proceeding when using the skip command
var dialogue_finished_typing = false

# the current dialogue line
var dialogue_line: DialogueLine:
	set(next_line):

		if not next_line:
				queue_free()
				return

		dialogue_line = next_line
		
		self.character_name.visible = !dialogue_line.character.is_empty()
		self.character_name.text = tr(dialogue_line.character, "dialogue")
		#TODO: color name label for specific characters

		# dialogue_label.modulate.a = 0
		dialogue_label.dialogue_line = dialogue_line

		# show any responses we have
		if dialogue_line.responses.size() > 0:
			self.response_box.show()
			for response in dialogue_line.responses:

				if !response.is_allowed:
					continue

				#duplicate the template
				var item: Button = self.response_template.duplicate(0)
				
				item.name = "Response%d" % self.response_box.get_child(0).get_child_count()
				item.text = response.text
				self.response_box.get_child(0).add_child(item)

				item.button_up.connect(_on_response_button_up.bind(item))

		if !dialogue_line.text.is_empty():
			self.dialogue_label.type_out()
			await self.dialogue_label.finished_typing

		# wait for input
		if dialogue_line.responses.size() > 0:
			for i in self.response_box.get_child(0).get_child_count():
				if i == 0:
					continue
				self.response_box.get_child(0).get_child(i).show()
		elif dialogue_line.time != null:
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)

		self.dialogue_finished_typing = false

	get:
		return dialogue_line

# Called when the node enters the scene tree for the first time.
func _ready():
	self.response_template.hide()
	self.response_box.hide()
	self.character_name.text = ""
	self.dialogue_label.text = ""

	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)

#called when any input is given
# func _input(event):
# 	if event.is_action_pressed("INPUT_progress_dialogue"):
# 		if self.dialogue_line.responses.size() == 0 && \
# 			self.dialogue_finished_typing:
# 			next(self.dialogue_line.next_id)

## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	self.temporary_game_states = extra_game_states
	# is_waiting_for_input = false
	self.dialogue_res = dialogue_resource
	
	self.dialogue_line = await self.dialogue_res.get_next_dialogue_line(title, temporary_game_states)

## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await self.dialogue_res.get_next_dialogue_line(next_id, temporary_game_states)

func disable_response_buttons():
	for i in self.response_box.get_child(0).get_child_count():
		if i == 0:
			continue
		self.response_box.get_child(0).get_child(i).hide()
		self.response_box.get_child(0).get_child(i).queue_free()

	self.response_box.hide()

## SIGNALS

func _on_mutated(_mutation: Dictionary) -> void:
	pass


func _on_dialogue_label_finished_typing():
	self.dialogue_finished_typing = true

func _on_dialogue_label_continue_dialogue():
	if self.dialogue_line.responses.size() == 0:
		next(self.dialogue_line.next_id)

func _on_response_button_up(item: Button):
	var item_name = item.name.get_slice("%d", 5)
	var index = int(item_name) - 1#.erase(item_name.length - 1, 1))
	disable_response_buttons()
	next(self.dialogue_line.responses[index].next_id)
