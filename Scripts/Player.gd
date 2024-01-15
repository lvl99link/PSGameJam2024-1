class_name Player
extends Node

var roster: Array[Slime]
var player_num: int

func remove_slime_from_roster(slime_to_remove: Slime) -> void:
	var idx = 0
	for slime in roster:
		if slime == slime_to_remove:
			roster.remove_at(idx)
			break
		idx += 1
