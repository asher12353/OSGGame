extends Spell
class_name Banana

func _init():
	nameString = "Banana"
	textString = "Give a minion +1/+1"
	cardArtPath = "res://Cards/Spells/Banana/Banana.png"
	fullArtPath = "res://Cards/Spells/Banana/BananaFull.png"
	isTargeted = true
	_Spell()

func _playSpell(target):
	target._WhenBananaIsPlayedOnSelf()
	target._giveStats(1, 1)
	queue_free()
	Input.set_custom_mouse_cursor(null)
