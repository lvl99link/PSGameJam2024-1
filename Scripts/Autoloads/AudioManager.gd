extends Node

const OST_BGM_1_RIME = preload("res://Assets/Music/OST_BGM_1_RIME.ogg")
const OST_BGM_PAUSE = preload("res://Assets/Music/OST_BGM_PAUSE.ogg")

var menu_music_player: AudioStreamPlayer
var game_music_player: AudioStreamPlayer

var current_player: AudioStreamPlayer = null

func _ready() -> void:
	SceneTransition.scene_changed.connect(on_scene_changed)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	menu_music_player = initialize_player(OST_BGM_PAUSE)
	game_music_player = initialize_player(OST_BGM_1_RIME)
	
	if get_tree().current_scene.name == "MainMenu":
		current_player = menu_music_player
	else:
		current_player = game_music_player
	#var tween = get_tree().create_tween()
	#tween.tween_property(current_player, "volume_db", 0, 0.5)
	current_player.volume_db = 0 # 0db = full volume

func initialize_player(stream: Resource) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = "Music"
	player.stream = stream
	player.volume_db = -72
	player.autoplay = true
	add_child(player)
	return player

func crossfade(new_player: AudioStreamPlayer, fade_in_t: float = 1, fade_out_t: float = 1) -> void:
	# Accept a new music player to start playing
	# Fade out the current player
	# Fade in the new player
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(current_player, "volume_db", -72, fade_out_t)
	tween.tween_property(new_player, "volume_db", 0, fade_in_t)
	await tween.finished
	current_player = new_player

func on_scene_changed() -> void:
	# Automatically handle audio shifting based on the current scene
	var tween = get_tree().create_tween().set_parallel()
	if get_tree().current_scene.name == "MainMenu":
		tween.tween_property(game_music_player, "volume_db", -72, 2) # Fade out the game
		tween.tween_property(menu_music_player, "volume_db", 0, .25) # Fade in the menu
		current_player = menu_music_player
	else:
		tween.tween_property(menu_music_player, "volume_db", -72, 2) # Fade out the menu
		tween.tween_property(game_music_player, "volume_db", 0, .25) # Fade in the game
		current_player = game_music_player
