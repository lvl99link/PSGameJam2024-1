extends State

var can_dizzy: bool = false

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass

func physics_update(_delta: float) -> void:
	# If we have not been moving for a few seconds, we can automatically transition
	# to the 'dizzy' state for a few seconds before automatically entering the idle state.
	var slime = state_machine.parent as Slime
	var speed = sqrt( pow(slime.linear_velocity.x, 2) + pow(slime.linear_velocity.y, 2))
	
	var speed_to_fps = clamp(speed / 10, 6, 24 )
	slime.sliming_particles.emitting = speed > 100
	slime.sprite.sprite_frames.set_animation_speed("sliming", speed_to_fps)
	
	if speed < 10:
		await get_tree().create_timer(1).timeout
		if state_machine.state.name != "SLIMING": return
		if speed < 10:
			state_machine.transition_to("IDLE")
			return
			#if can_dizzy:
				#can_dizzy = false
				#state_machine.transition_to("DIZZY")
			#else:
				#state_machine.transition_to("IDLE")
			
	
	if speed < 100: # start fading out the audio to match the slime slowing down
		var tween = get_tree().create_tween()
		var tween2 = get_tree().create_tween()
		tween.tween_property(slime.ground_audio_player, "volume_db", -50, 3)
		tween2.tween_property(slime.slime_audio_player, "volume_db", -25, 3)
		await tween.finished
		slime.ground_audio_player.stop()
	if speed > 300:
		can_dizzy = true

func enter(_msg := {}) -> void:
	# When we enter the sliming state (manually set after the launch function)
	# Start playing the corresponding animations. Mainly the spinning loop.
	# However we can maybe chain that to run after the initial getting flicked animation.
	can_dizzy = false
	var slime = state_machine.parent as Slime
	slime.sliming_particles.emitting = true
	slime.sprite.play("sliming")
	slime.slime_audio_player.stream = slime.slime_data.SLIME_SLIDE_BASE
	slime.ground_audio_player.stream = slime.slime_data.ICE_SLIDE_BASE
	slime.slime_audio_player.play()
	slime.ground_audio_player.play()

func exit() -> void:
	var slime = state_machine.parent as Slime
	slime.sliming_particles.emitting = false
	slime.sliming_particles.amount = 50
	slime.slime_audio_player.stop()
	slime.ground_audio_player.stop()
	
	if can_dizzy:
		Globals.play_random_sfx(slime.slime_data.slime_dizzys)
		slime.sprite.play("dizzy")
	#state_machine.transition_to("IDLE")
