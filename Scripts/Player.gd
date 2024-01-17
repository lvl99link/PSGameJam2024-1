class_name Player
extends Node

var roster: Array[Slime] # Persistent list of slimes that belongs to the player
var available_roster: Array[Slime] # List of slimes available to the player (slimes can be removed)
var slimes_on_field: Array[Slime] # List of slimes on the field that belong to the player
var player_num: int # Player 1, 2, etc.
var score: int = 0

func remove_slime_from_roster(slime_to_remove: Slime) -> void:
	var idx = 0
	for slime in available_roster:
		if slime == slime_to_remove:
			available_roster.remove_at(idx)
			break
		idx += 1
