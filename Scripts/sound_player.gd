class_name SoundPlayer
extends AudioStreamPlayer2D


#---Set file_path relative to res://Audio/Sounds/, for example Dialogue/acceptSelect.wav---#
func play_sound(file_path : String):
	var full_file_path = "res://Audio/Sounds/"+file_path
	var sound_stream = load(full_file_path)
	if !is_playing():
		stream = sound_stream
		play()
