class_name Player
extends Node

var roster: Array[Slime] # Persistent list of slimes that belongs to the player
var available_roster: Array[Slime] # List of slimes available to the player (slimes can be removed)
var slimes_on_field: Array[Slime] # List of slimes on the field that belong to the player
var player_num: int = 1 # Player 1, 2, etc.
var score: int = 0
var color_by_player_num: Array[Color] = [
	Color(0,1,0,0.7), # Green
	Color(1,0,0,0.7), # Red
	Color(0,0,1,0.7), # Blue
	Color(1,1,0,0.7)  # Yellow
]

func remove_slime_from_roster(slime_to_remove: Slime) -> void:
	var idx = 0
	for slime in available_roster:
		if slime == slime_to_remove:
			available_roster.remove_at(idx)
			break
		idx += 1
