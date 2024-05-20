# Base class Screen
extends Control
class_name Screen

func save():
	var saveDict = {
		"name" : name
	}
	return saveDict
