class_name Player
extends CharacterBody2D

@export var animator : AnimatedSprite2D
@export var dialogueController : Node2D
@export var inventoryController : Inventory
@export var time_controller : TimeController

var is_active : bool = true

var direction : Vector2

func _process(_delta):
	print(is_active)
	if direction.x > 0:
		animator.flip_h = false
	elif direction.x < 0:
		animator.flip_h = true
	# Dont _process when rewinding
	if time_controller.rewinding : is_active = false
	elif dialogueController.dialoguePanel.visible : is_active = false
	elif inventoryController.inventory_ui.canvas.visible : is_active = false
	else: is_active = true
	
	if is_active:
		if Input.is_action_just_pressed('rewind'):
			time_controller.rewind()
		
		direction = Input.get_vector("left", "right", "up", "down")
