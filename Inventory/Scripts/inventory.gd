class_name Inventory
extends Node2D

var save_file_path = ""
var save_file_name = "PlayerSave.tres"
var playerData = PlayerData.new()

@export var inventory_ui : InventoryUI
@onready var sound_player : SoundPlayer = $CanvasLayer/SoundPlayer 
@onready var music_player : MusicPlayer = $CanvasLayer/MusicPlayer 

@export var change_select_sound := 'Inventory/changeSelect.wav'
@export var accept_select_sound := 'Inventory/acceptSelect.wav'

func _process(delta):
	if Input.is_action_just_pressed("add_item"):
		add_item(load('res://Inventory/Items/test_item.tres'))
		add_item(load('res://Inventory/Items/test_item2.tres'))
		inventory_ui.render_items()
	if Input.is_action_just_pressed("save"):
		save()
	if Input.is_action_just_pressed("load"):
		load_data()

func resource_to_dict(item : ItemResource) -> Dictionary:
	return {"name": item.name, "description": item.description, "action": item.action, "quantity": item.quantity};

func load_data():
	playerData = ResourceLoader.load(save_file_path + save_file_name)
	print(playerData.inventory[0].quantity)

func save():
	print(playerData.inventory[0].quantity)
	ResourceSaver.save(playerData, save_file_path + save_file_name)

#---Function adds a new item to the inventory---#
func add_item(item : ItemResource) -> void:
	for index in range(playerData.inventory.size()):
		if item.name == playerData.inventory[index].name:
			playerData.inventory[index].quantity += 1
			return
	playerData.inventory.append(resource_to_dict(item))

#---Function that removes an item from the inventory---#
func remove_item(item : Dictionary) -> void:
	for index in range(playerData.inventory.size()):
		if item.name == playerData.inventory[index].name:
			if item.quantity > 1:
				playerData.inventory[index].quantity -= 1
			else:
				playerData.inventory.erase(item)
			return

