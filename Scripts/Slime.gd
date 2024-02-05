class_name Slime
extends RigidBody2D

signal slime_impacted(slime: Slime)

#const JAM_A_SLIME_A_BIG = preload("res://Assets/Art/Slimes/Jam-A-Slime-A-Big.png")
#const RED_SLIME = preload("res://Assets/Art/Slimes/Red_Slime.png")

#const slime_sprite_by_player: Array[Texture2D] = [JAM_A_SLIME_A_BIG, RED_SLIME]


#region IMPORT ALL SLIME SOUND RELATED AUDIO SFX
const SLIME_A_IMPACT_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_A.ogg")
const SLIME_A_IMPACT_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_B.ogg")
const SLIME_A_IMPACT_C = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_C.ogg")
const SLIME_A_IMPACT_D = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Impact_D.ogg")

const SLIME_A_SELECT_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Select_A.ogg")
const SLIME_A_SELECT_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Select_B.ogg")

const SLIME_A_THROW_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Throw_A.ogg")

const SLIME_A_DIZZY_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Dizzy_A.ogg")
const SLIME_A_DIZZY_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Dizzy_B.ogg")
const SLIME_A_DIZZY_C = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Dizzy_C.ogg")

const SLIME_A_HAHA = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Haha.ogg")
const SLIME_A_SURPRISE_A = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Surprise_A.ogg")
const SLIME_A_SURPRISE_B = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Surprise_B.ogg")
const SLIME_A_SURPRISE_C = preload("res://Assets/SFX/OGG/Slimes/Slime_A_Surprise_C.ogg")

const SLIME_SLIDE_BASE = preload("res://Assets/SFX/OGG/slime_slide_BASE.ogg")
const SLIME_IMPACT_SLAP = preload("res://Assets/SFX/OGG/Impacts/Slime_impact_slap.ogg")
const ICE_SLIDE_BASE = preload("res://Assets/SFX/OGG/ice_slide_BASE.ogg")
#endregion

#region CONSTRUCT SFX VARIANT ARRAYS
@onready var slime_impacts: Array[AudioStreamOggVorbis] = [
	SLIME_A_IMPACT_A,
	SLIME_A_IMPACT_B,
	SLIME_A_IMPACT_C,
	SLIME_A_IMPACT_D
]
@onready var slime_selects: Array[AudioStreamOggVorbis] = [
	SLIME_A_SELECT_A,
	SLIME_A_SELECT_B
]
@onready var slime_throws: Array[AudioStreamOggVorbis] = [
	SLIME_A_THROW_A,
	SLIME_A_IMPACT_A,
	SLIME_A_IMPACT_B,
	SLIME_A_IMPACT_C,
	SLIME_A_IMPACT_D
]
@onready var slime_dizzys: Array[AudioStreamOggVorbis] = [
	SLIME_A_DIZZY_A,
	SLIME_A_DIZZY_B,
	SLIME_A_DIZZY_C
]
@onready var slime_surprised: Array[AudioStreamOggVorbis] = [
	SLIME_A_SURPRISE_A,
	SLIME_A_SURPRISE_B,
	SLIME_A_SURPRISE_C
]
#endregion

@onready var state_manager: StateMachine = $StateManager
@onready var slime_audio_player: AudioStreamPlayer2D = $SlimeTrailAudioPlayer
@onready var ground_audio_player: AudioStreamPlayer2D = $SlimeGroundAudioPlayer
@onready var trail: Trail = $Node2D/Trail
@onready var child_container: Node2D = $Node2D # Can't resize rigidbodies, so make a container to resize their children
@onready var sprite: AnimatedSprite2D = $Node2D/Sprite2D
@onready var split_cooldown_timer: Timer = $SplitCooldownTimer

@onready var hit_particles: CPUParticles2D = $HitParticles
@onready var sliming_particles: CPUParticles2D = $SlimingParticles

@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var trail_detection_area: Area2D = $Node2D/TrailDetectionArea
@onready var score_detection_area: Area2D = $Node2D/ScoreDetectionArea
@onready var start_detection_area: Area2D = $Node2D/StartLineDetectionArea
@onready var slime_detection_area: Area2D = $Node2D/SlimeDetectionArea

var owned_by: Player
var multiplier: int = 4
var slime_friction: float = 1.4
var can_split: bool = true

func _ready() -> void:
	linear_damp = Globals.FRICTION
	var color = Globals.slime_color_by_player[owned_by.player_num - 1]
	color.a = 1
	sprite.material.set_shader_parameter("modulate_color", color)
	
	trail.line.default_color = Globals.trail_color_by_player[owned_by.player_num - 1]
	hit_particles.color = Globals.slime_color_by_player[owned_by.player_num - 1]
	sliming_particles.color = Globals.slime_color_by_player[owned_by.player_num - 1]
	# Randomizes the slime's blinking pace.
	sprite.sprite_frames.set_frame("default", 0, sprite.sprite_frames.get_frame_texture("default", 0), randi_range(24,64))

func _physics_process(_delta: float) -> void:
	handle_slime_trail_friction()
	# Resets the can_split once it's had a moment to settle down
	if not can_split and linear_velocity.x < 10:
		await get_tree().create_timer(1).timeout
		if linear_velocity.x < 10: can_split = true

func handle_slime_trail_friction() -> void:
	# Applies greater friction if the given slime is overlapping a slime trail
	# NOTE: Slime is not slowed down by its own slime trail. Could be a feature or a bug.
	# 		Don't want it to be slowed by its own trail as its launched.
	var trails = trail_detection_area.get_overlapping_areas()
	if len(trails) > 0:
		for t in trails:
			if t != trail.collision_area:
				linear_damp = Globals.FRICTION * slime_friction
	else:
		linear_damp = Globals.FRICTION

func calculate_score() -> int:
	# Gets all the 'score areas' that the slime might be overlapping
	# Really should offload this responsibility to the Target class.
	var targets = score_detection_area.get_overlapping_areas()
	if len(targets) > 0:
		# Check if the slime is in a valid scoring area. Get's the latest touched overlapping area.
		var target: Target = targets[len(targets) - 1] as Target
		if multiplier not in target.allowed_multipliers: return 0
		set_outline_by_target(target, false) # Changes the outline just in case they're out of sync
		return target.value * multiplier
	return 0

func set_outline(color: Color, width: float) -> void:
	(sprite.material as ShaderMaterial).set_shader_parameter("width", width)
	(sprite.material as ShaderMaterial).set_shader_parameter("color", color)

func set_outline_by_target(target: Target, play_audio: bool = true) -> void:
	var audio_to_play = null
	if target.value < 10: 
		audio_to_play = target.SCORING_NOTE_BLUE
		set_outline(Color(0,0,1), 20)
	elif target.value < 25: 
		audio_to_play = target.SCORING_NOTE_YELLOW
		set_outline(Color(1,1,0), 20)
	elif target.value >= 25: 
		audio_to_play = target.SCORING_NOTE_RED
		set_outline(Color(1,0,0), 20)
	if play_audio: Globals.play_audio(audio_to_play)

func split(hit_vector: Vector2 = Vector2.ZERO) -> void:
	# Function handles the 'splitting' of a slime when impacted by another
	# Resizes and adjusts properties before 'cloning' the instance
	# Instance is instantiated with some repositioning based on the vector
	# perpendicular to the direction it was hit from
	if multiplier <= 1: return
	
	child_container.scale *= 0.65
	collider.scale *= 0.65
	trail.width *= 0.65
	mass /= 2
	multiplier /= 2
	can_split = false

	trail.can_draw = false # Now that we're splitting, we don't want to keep drawing the original trail
	var new_trail = trail.duplicate(4) as Trail # instantiate a new trail with the same properties as the old trail
	new_trail.can_draw = true
	new_trail.line = trail.line
	
	child_container.call_deferred("add_child", new_trail)
	set_deferred("trail", new_trail)
	
	var perpendicular = Vector2(hit_vector.y, -hit_vector.x)
	var height = collider.shape.get_rect().size.x/3
	var new_slime = clone()
	global_position += height * perpendicular
	new_slime.global_position -= height * perpendicular
	linear_velocity = linear_velocity.rotated(perpendicular.angle()/8)
	new_slime.linear_velocity = new_slime.linear_velocity.rotated(-perpendicular.angle()/8)
	call_deferred("spawn", new_slime)
	
	Globals.play_random_sfx(slime_impacts)

func _on_slime_detection_area_body_entered(body: Slime) -> void:
	if body == self: return
	if multiplier <= 1: return
	if not can_split: return 
	var directional_velocity = sqrt(pow(linear_velocity.x, 2) + pow(linear_velocity.y, 2))
	print(linear_velocity, " ", body.linear_velocity)
	print(directional_velocity, " ", Engine.time_scale)
	if abs(directional_velocity) < 10: return
	state_manager.transition_to("IMPACTING")

	slime_impacted.emit(self) # Probably should remove with rework of final slaunch
	# Make it more likely to combo slime splits during hit stop frames
	var combo_mod = clamp(Engine.time_scale, 0.5, 1) 
	if abs(directional_velocity) < 250 * combo_mod: return
	if not Globals.is_final_turn: # super hacky, probably remove
		Globals.freeze_frame(0.1, 0.18)
	Globals.shake(0.18)

	var hit_vector = body.global_position.direction_to(global_position)
	split(hit_vector)

func clone() -> Slime:
	# Function creates and returns a fully constructed clone of the current instance of this slime
	# It has to set each variable in this script manually, else it'll be null
	# I'm honestly not sure which types of values *need* to be set. This seems to work fine for now.
	var new_slime = duplicate(5) as Slime
	new_slime.owned_by = owned_by
	new_slime.multiplier = multiplier
	new_slime.can_split = false
	new_slime.trail = trail.duplicate(5) as Trail
	new_slime.trail.width = trail.width
	owned_by.slimes_on_field.append(new_slime)
	#new_slime.sprite = sprite.duplicate(5)
	# I think we need to set the initial state, somehow
	
	return new_slime

func spawn(new_slime: Slime) -> void:
	get_parent().add_child(new_slime)
	new_slime.sprite.material = sprite.material.duplicate()
	new_slime.trail.can_draw = true
	new_slime.state_manager.transition_to("IMPACTING")

func _on_body_entered(body: Node) -> void:
	# Whenever we hit another physics body
	Globals.play_audio(SLIME_IMPACT_SLAP)
	
	var directional_v = sqrt(pow(linear_velocity.x, 2) + pow(linear_velocity.y, 2))
	if body is StaticBody2D and directional_v > 10: # Only reading walls
		# Enter impacting state
		# Change the other state to splitting?
		state_manager.transition_to("IMPACTING")
		Globals.play_audio(SLIME_IMPACT_SLAP)
		Globals.shake(0.18)
		hit_particles.emitting = true

func _on_score_detection_area_area_entered(target: Target) -> void:
	if multiplier not in target.allowed_multipliers: return
	if not score_detection_area.has_overlapping_areas(): return
	set_outline_by_target(target)

func _on_score_detection_area_area_exited(target: Target) -> void:
	if multiplier not in target.allowed_multipliers: return
	if score_detection_area.has_overlapping_areas(): return
	set_outline(Color(0,0,0), 0)
