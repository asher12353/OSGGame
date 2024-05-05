extends Room

func _on_button_pressed():
	var parent = get_parent()
	parent.endlessMode = true
	parent.isShop = true
	parent._changeScreenToNextRoom()
