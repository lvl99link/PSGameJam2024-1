extends Node

const OST_BGM_0_DAWN = preload("res://Assets/Music/OST_BGM_0_DAWN.ogg")
const OST_BGM_1_RIME = preload("res://Assets/Music/OST_BGM_1_RIME.ogg")
const OST_BGM_PAUSE = preload("res://Assets/Music/OST_BGM_PAUSE.ogg")
const OST_BGM_MATCH_END = preload("res://Assets/Music/OST_BGM_MATCH_END.ogg")

var menu_music_player: AudioStreamPlayer
var game_music_player: AudioStreamPlayer
var victory_music_player: AudioStreamPlayer

var current_player: AudioStreamPlayer = null

func _ready() -> void:
	SceneTransition.scene_changed.connect(on_scene_changed)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	menu_music_player = initialize_player(OST_BGM_0_DAWN)
	game_music_player = initialize_player(OST_BGM_1_RIME)
	victory_music_player = initialize_player(OST_BGM_MATCH_END)
	
	if get_tree().current_scene.name == "MainMenu":
		current_player = menu_music_player
	else:
		current_player = game_music_player
	#current_player.stream_paused = false
	current_player.volume_db = 0 # 0db = full volume

func initialize_player(stream: Resource) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = "Music"
	player.stream = stream
	player.volume_db = -72
	player.autoplay = true
	#player.stream_paused = true
	add_child(player)
	return player

func crossfade(new_player: AudioStreamPlayer, fade_in_t: float = 1, fade_out_t: float = 1) -> void:
	# Accept a new music player to start playing
	# Fade out the current player
	# Fade in the new player
	if new_player == current_player: return
	var tween = get_tree().create_tween().set_parallel()
	#new_player.stream_paused = false
	tween.tween_property(current_player, "volume_db", -72, fade_out_t)
	tween.tween_property(new_player, "volume_db", 0, fade_in_t)
	await tween.finished
	current_player = new_player
	#current_player.stream_paused = true

func play(player: AudioStreamPlayer, fade_in_t: float = 1) -> void:
	# Start an existing audio player (from the paused state)
	# Does not add to or overwrite the main 'current player'
	# Only meant to play atop existing elements.
	var tween = get_tree().create_tween()
	#player.stream_paused = false
	tween.tween_property(player, "volume_db", 0, fade_in_t)

func stop(player: AudioStreamPlayer, fade_out_t: float = 1) -> void:
	# Stop a specific existing audio player (pauses)
	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_db", -72, fade_out_t)
	await tween.finished
	#player.stream_paused = true

func on_scene_changed() -> void:
	# Automatically handle audio shifting based on the current scene
	# hack fix to not crossfade if we're already running a fade when triggered
	if current_player.volume_db != 0: 
		return
	
	if get_tree().current_scene.name == "MainMenu":
		await crossfade(menu_music_player, 0.25, 2)
	else:
		await crossfade(game_music_player, 0.25, 2)
	# If we're going to the main menu, stop all streams except for the menu track
	# WARNING: Bugged due to timing 
	for node in get_children():
		if node is AudioStreamPlayer and node != current_player:
			stop(node)
