extends AudioStreamPlayer

const BATTLE = preload("res://Audio/Music/battle.mp3")
const SHOP = preload("res://Audio/Music/shop.mp3")
const TITLE_SCREEN = preload("res://Audio/Music/titleScreen.mp3")

var nextSong : AudioStreamMP3 = null

var lowerDecible = -18.0
var currentLowerDecible = lowerDecible
var higherDecible = 0
var currentHigherDecible = higherDecible
var volumeRate = 13

func _ready():
	volume_db = lowerDecible
	
func _process(delta):
	if currentLowerDecible == 2 * lowerDecible:
		volume_db = -80
	elif nextSong != null:
		if volume_db > currentLowerDecible:
			volume_db -= volumeRate * delta
		else:
			stream = nextSong
			nextSong = null
			play()
	elif volume_db < currentHigherDecible:
		volume_db += volumeRate * delta
	if not playing:
		play()

func _changeMusic(song : AudioStreamMP3):
	if song != stream:
		nextSong = song
