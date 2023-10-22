extends Control

@export var item_name : String
@export var item_count : int

var selected : bool = false

func _ready():
	$Label.set_text("[x" + str(item_count) + "] " + item_name)

func _process(delta):
	if selected:
		self.modulate = Color(175, 0, 150, 255)
	else:
		self.modulate = Color(255, 255, 255, 255)
