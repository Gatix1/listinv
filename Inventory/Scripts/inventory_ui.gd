class_name InventoryUI
extends ScrollContainer

@export var inventory : Inventory
@export var container : VBoxContainer
@export var canvas : CanvasLayer
@export var more_info_panel : InventoryMoreInfo
@export var items_actions : ItemsActions

var selected_item := 0

func _ready():
	canvas.visible = false

func _process(delta):
	if Input.is_action_just_pressed("open_inventory") and not canvas.visible:
		canvas.visible = true
		render_items()
		inventory.sound_player.play_sound(inventory.accept_select_sound)
		render_selected()
	if Input.is_action_just_pressed("ui_cancel") and canvas.visible and more_info_panel.visible:
		inventory.sound_player.play_sound(inventory.accept_select_sound)
		more_info_panel.visible = false
	elif Input.is_action_just_pressed("ui_cancel") and canvas.visible and not more_info_panel.visible:
		inventory.sound_player.play_sound(inventory.accept_select_sound)
		canvas.visible = false

	if Input.is_action_just_pressed("ui_accept") and container.get_children().size() != 0 and canvas.visible:
		inventory.sound_player.play_sound(inventory.accept_select_sound)
		if more_info_panel.visible:
			if more_info_panel.selected_option == more_info_panel.options.DROP:
				inventory.remove_item(inventory.inventory[selected_item])
				more_info_panel.visible = false
				render_items()
				render_selected()  
			elif more_info_panel.selected_option == more_info_panel.options.USE:
				if inventory.inventory[selected_item].action != "":
					items_actions.call_deferred(inventory.inventory[selected_item].action)
		else:
			more_info_panel.visible = true
		
	if not canvas.visible: return
	if more_info_panel.visible: return
	
	if Input.is_action_just_pressed("ui_down") and selected_item < inventory.inventory.size()-1:
		selected_item += 1
		inventory.sound_player.play_sound(inventory.change_select_sound)
		render_selected()
	elif Input.is_action_just_pressed("ui_up") and selected_item > 0:
		selected_item -= 1
		inventory.sound_player.play_sound(inventory.change_select_sound)
		render_selected()
			

func render_selected():
	if selected_item > inventory.inventory.size()-1 or selected_item < 0:
		selected_item = 0
		
	for i in range(container.get_children().size()):
		if selected_item == i:
			more_info_panel.item_name = inventory.inventory[i].name
			more_info_panel.item_description = inventory.inventory[i].description
			container.get_children()[i].selected = true
			for j in range(container.get_children().size()):
				if selected_item != j:
					container.get_children()[j].selected = false

func render_items():
	if inventory.inventory.size() == 0:
		more_info_panel.visible = false
		
	for child in container.get_children():
		container.remove_child(child)
	for i in range(inventory.inventory.size()):
		var ui_item = preload("res://Inventory/inventory_ui_item.tscn")
		var ui_item_instance = ui_item.instantiate()
		ui_item_instance.item_name = inventory.inventory[i].name
		ui_item_instance.item_count = inventory.inventory[i].quantity
		container.add_child(ui_item_instance)
