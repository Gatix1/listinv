class_name MusicPlayer
extends AudioStreamPlayer2D


#---Set file_path relative to res://Audio/Sounds/, for example Dialogue/acceptSelect.wav---#
func play_music(file_path : String):
	var full_file_path = "res://Audio/Music/"+file_path
	var sound_stream = load(full_file_path)
	stream = sound_stream
	stop()
	play()
