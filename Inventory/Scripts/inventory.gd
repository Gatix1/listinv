class_name Inventory
extends Node2D

var inventory := [] # List to store inv items
@export var inventory_ui : InventoryUI
@onready var sound_player : SoundPlayer = $CanvasLayer/SoundPlayer  

@export var change_select_sound := 'Inventory/changeSelect.wav'
@export var accept_select_sound := 'Inventory/acceptSelect.wav'

func _process(delta):
	if Input.is_action_just_pressed("add_item"):
		add_item(preload('res://Inventory/Items/test_item.tres'))
		add_item(preload('res://Inventory/Items/test_item2.tres'))
		inventory_ui.render_items()

#---Function adds a new item to the inventory---#
func add_item(item : ItemResource) -> void:
	for index in range(inventory.size()):
		if item.name == inventory[index].name:
			inventory[index].quantity += 1
			return
	inventory.append(item)

#---Function that removes an item from the inventory---#
func remove_item(item : ItemResource) -> void:
	for index in range(inventory.size()):
		if item.name == inventory[index].name:
			if item.quantity > 1:
				inventory[index].quantity -= 1
			else:
				inventory.erase(item)
			return

