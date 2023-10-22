class_name ItemsActions
extends Node

@export var inventory : Inventory

func start_music():
	inventory.music_player.play_music("nice_song.mp3")
