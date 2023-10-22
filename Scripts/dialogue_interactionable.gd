extends Node

var in_area = false
@onready 
var dialogue_file_name = get_node('..').dialogue_file_name
@onready var dialogue_controller = get_node('..').dialogue_controller

func _process(_delta):
	if Input.is_action_just_released("interact") and in_area and (not dialogue_controller.dialoguePanel.visible):
		dialogue_controller.LoadFile(dialogue_file_name)
		dialogue_controller.StartDialogue()

func _on_body_entered(body):
	in_area = true


func _on_body_exited(body):
	in_area = false
