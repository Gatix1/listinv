class_name InventoryMoreInfo
extends Sprite2D

enum options {
	USE,
	DROP
}

@export var inventory : Inventory
@onready var use_label = $UseLabel
@onready var drop_label = $DropLabel
var item_name : String = "Item Name"
var item_description : String = "Item Description Text"
var selected_option : options = options.USE


func _ready():
	self.visible = false

func _process(delta):
	# Not execute if not visible
	if not self.visible : return
	
	$ItemNameLabel.set_text("[center]"+item_name)
	$ItemDescLabel.set_text("[center]"+item_description)
	
	# Color right label as selected
	if selected_option == options.USE:
		use_label.modulate = Color(175, 0, 150, 255)
		drop_label.modulate = Color(255, 255, 255, 255)
	else:
		drop_label.modulate = Color(175, 0, 150, 255)
		use_label.modulate = Color(255, 255, 255, 255)
	
	if Input.is_action_just_pressed("ui_right") and selected_option == options.USE:
		inventory.sound_player.play_sound(inventory.change_select_sound)
		selected_option = options.DROP
	if Input.is_action_just_pressed('ui_left') and selected_option == options.DROP:
		inventory.sound_player.play_sound(inventory.change_select_sound)
		selected_option = options.USE
