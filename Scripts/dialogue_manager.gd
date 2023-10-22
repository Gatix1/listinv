extends Node2D

#---File---#
@export var file_name := "test.json" # You could pass a new file here on area body enter or whenever you feel like
var nodes # containes all the nodes of the current dialogue

@export var dialogueFunctions : DialogueFunctions

#----DATA (from file)-----#
var curent_node_id := -1 # handles the current node we are traversing Note: -1 exits the dialogue
var curent_node_name := "" # name of the speaker
var curent_node_image := ""
var curent_node_text := "" # dialogue text
var curent_node_speed := 0.1
var curent_node_next_id := -1 # connect to the next node Note: ignored if curent_node_choices has things inside
var curent_node_choices := [] # If you want more than one possible answear, you should fill this up

var force := false # force start the dialogue
var random := false # Start from random node

#------UI--------#
var dialogueText
var dialoguePanel
var dialogueName
var dialogueImage
var dialogueButtons
var arrowSprite

#-----Buttons Variables-----#
var buttonSelected = 0
var MAX_BUTTON_SELECTED = 3
var MIN_BUTTON_SELECTED = 0


var buttonSprite = load("res://Sprites/Dialogue/DisabledChoice.png")
var activeButtonSprite = load("res://Sprites/Dialogue/ActivatedChoice.png")

#-----Sound Player-----#
var sound_player
var current_node_print_sound
var changeSelectSound = "Dialogue/changeSelect.wav"
var acceptSelectSound = "Dialogue/acceptSelect.wav"

func _ready():
	# There are smarter and easier ways to get nodes in godot 4, kept like this for simplicity.
	dialogueText = get_node("CanvasLayer/DialogueText")
	dialoguePanel = self.get_node('CanvasLayer') #Less rewritting if you want to move the script to another object
	dialogueName = get_node("CanvasLayer/DialogueName")
	dialogueImage = get_node("CanvasLayer/CharacterImage")
	arrowSprite = get_node("CanvasLayer/Arrow")
	sound_player = get_node("CanvasLayer/SoundPlayer")
	dialogueButtons = [
		get_node("CanvasLayer/Control/DialogueButton"),
		get_node("CanvasLayer/Control/DialogueButton2"),
		get_node("CanvasLayer/Control/DialogueButton3"),
		get_node("CanvasLayer/Control/DialogueButton4")]

	@warning_ignore("narrowing_conversion")
	seed(Time.get_unix_time_from_system())
	#----HERE FOR PREVIEW----#
	LoadFile(file_name)
	StartDialogue()

func _process(_delta):
	if dialoguePanel.visible:
		if Input.is_action_just_pressed("right"):
			if (buttonSelected-1) >= MIN_BUTTON_SELECTED:
				sound_player.play_sound(changeSelectSound)
				buttonSelected -= 1
				UpdateButtons()
		if Input.is_action_just_pressed("left"):
			if (buttonSelected+1) <= MAX_BUTTON_SELECTED:
				sound_player.play_sound(changeSelectSound)
				buttonSelected += 1
				UpdateButtons()
		if Input.is_action_just_pressed("dialogue_continue"):
			sound_player.play_sound(acceptSelectSound)
			if dialogueText.visible_characters < dialogueText.text.length():
				dialogueText.visible_characters = dialogueText.text.length()
			else:
				if curent_node_choices.size() > 1:
					if curent_node_choices[buttonSelected]["action"].length() > 0:
						dialogueFunctions.call_deferred(curent_node_choices[buttonSelected]["action"]) 
					choiseProcess(curent_node_choices[buttonSelected]["next_id"])
				else:
					choiseProcess(curent_node_next_id)

func LoadFile(fname):
	file_name = fname
	if FileAccess.file_exists("res://Dialogues/"+file_name):
		var file = FileAccess.open("res://Dialogues/"+ file_name, FileAccess.READ)
		var test_json_conv = JSON.new()
		test_json_conv.parse(file.get_as_text())
		var json_result = test_json_conv.get_data()
		force = bool(json_result["Force"])
		random = bool(json_result["Random"])
		curent_node_id = 0
		nodes = json_result["Nodes"]
		file.close()
	else:
		print("Dialogue: File Open Error")
	if force:
		StartDialogue()

#-----Traversing Graph-----#
func StartDialogue():
	if nodes:
		if random:
			var temp = []
			for x in nodes:
				temp.append(x["id"])
			curent_node_id = temp[randi()%temp.size()]
		else:
			curent_node_id = 0
		HandleNode()
	else:
		print("Dialogue: Could not Find Nodes")

func EndDialogue():
	curent_node_id = -1

func NextNode(id):
	curent_node_id = id
	HandleNode()

#----Handle Current Node-----#
func HandleNode():
	if curent_node_id < 0 :
		EndDialogue()
	else:
		if !GrabNode(curent_node_id):
			EndDialogue()
	UpdateUI()

func GrabNode(id):
	for node in nodes:
		if int(node["id"]) == id:
			curent_node_name = node["name"]
			curent_node_text = node["text"]
			curent_node_speed = node["speed"]
			curent_node_image = "res://Sprites/Dialogue/Characters/"+node["image"]+".png"
			curent_node_next_id = int(node["next_id"])
			curent_node_choices = node["choices"]
			current_node_print_sound = "Dialogue/Characters/" + node["sound"] + ".wav"
			
			return true
	return false


func UpdateButtons():
	for x in clamp(curent_node_choices.size(),0,4):
		if x == buttonSelected:
			dialogueButtons[x].set_texture(activeButtonSprite)
		else:
			dialogueButtons[x].set_texture(buttonSprite)

#----Update UI-----#
func UpdateUI():
	if curent_node_id >= 0:
		arrowSprite.visible = false
		dialoguePanel.visible = true

		dialogueName.text = "[center]"+curent_node_name+"[/center]"
		dialogueText.text = curent_node_text
		for x in range(0,4):
			dialogueButtons[x].visible = false
		await printText(dialogueText)
		arrowSprite.visible = true
		dialogueImage.set_texture(load(curent_node_image))
		if curent_node_choices.size() > 0:
			for x in clamp(curent_node_choices.size(),0,4):
				MAX_BUTTON_SELECTED = curent_node_choices.size()-1
				dialogueButtons[x].get_node("Label").text = "[center]"+curent_node_choices[x]["text"]+"[/center]"
				UpdateButtons()
				
				# Render buttons
				dialogueButtons[x].visible = true

		else:
			for x in range(0,3):
				dialogueButtons[x].visible = false

	else:
		dialoguePanel.hide()

func printText(_text):
	_text.visible_characters = 0
	while _text.visible_characters < _text.text.length():
		if _text.text[_text.visible_characters-1] == '|':
			await get_tree().create_timer(curent_node_speed*2).timeout
			_text.text[_text.visible_characters-1] = ''
			continue
		_text.visible_characters += 1
		if _text.text[_text.visible_characters-1] != ' ':
			sound_player.play_sound(current_node_print_sound)
		await get_tree().create_timer(curent_node_speed).timeout

func choiseProcess(id):
	NextNode(id)
