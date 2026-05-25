#Author ANDY GASPAR
extends AudioStreamPlayer

@export var track_list:TrackList
@onready var masterBus : int = AudioServer.get_bus_index("Master")
@onready var sound_effects : int = AudioServer.get_bus_index("SFX")
var backgroundMusicIsOn = true
var musicBus = AudioServer.get_bus_index("Music")


#TODO: Connect to the AudioServer/Music bus. This is where we can send sound to a specfic bus (MUSIC)
# Load song into stream, DONE but will probs be replaced...
# Assign functions to what happens when the game starts. 
#Make sure it loops for now. DONE

#func _ready() -> void:
	#if backgroundMusicIsOn:
		#play()
	

#preload the song into the audio server, then play it. Maybe code it to auto play
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_music_enabled(enabled: bool): 
	backgroundMusicIsOn = enabled
	
	if enabled and !playing:
		play()
	elif !enabled and playing:
		stop()


func change_song(new_song:AudioStream):
	#if stream == new_song:
	#	return
	
	stop()
	stream = new_song
	play()


func set_music_volume(value: float):
	AudioServer.set_bus_volume_linear(musicBus,value)
	#works ok...


func set_master_volume(value: float): 
	AudioServer.set_bus_volume_linear(masterBus, value)


func set_sfx_volume(value: float):
	AudioServer.set_bus_volume_linear(sound_effects, value)
