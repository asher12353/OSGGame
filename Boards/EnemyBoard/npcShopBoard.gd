extends Board

func _ready():
	boardY = -120

# insert fancy refresh algorithm here later
func _refreshBoard():
	for child in get_children():
		remove_child(child)
	_createCard(Frg.new())
	_createCard(Frg.new())
	_createCard(OctoBro.new())
