#Author ANDY GASPAR
extends Node
@onready var masterBus : int = AudioServer.get_bus_index("Master")
@onready var player : AudioStreamPlayer = $MusicAudioStreamPlayer
var backgroundMusicIsOn = true
var musicBus = AudioServer.get_bus_index("Music")


#TODO: Connect to the AudioServer/Music bus. This is where we can send sound to a specfic bus (MUSIC)
# Load song into stream, DONE but will probs be replaced...
# Assign functions to what happens when the game starts. 
#Make sure it loops for now. DONE

func _ready() -> void:
	if backgroundMusicIsOn:
		player.play()
	

#preload the song into the audio server, then play it. Maybe code it to auto play
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func set_music_enabled(enabled: bool): 
	backgroundMusicIsOn = enabled
	
	if enabled and !player.playing:
		player.play()
	elif !enabled and player.playing:
		player.stop()
		
func set_music_volume(value: float):
	AudioServer.set_bus_volume_linear(musicBus,value)
	#works ok...
func set_master_volume(value: float): 
	AudioServer.set_bus_volume_linear(masterBus, value)
	
