extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var checkpoint_pos_y : float
var checkpoint_pos_x : float
var locked : bool = false
var current_color = "BLUE" # or "RED"
var checkpoint_color = "BLUE"

var walking_sound_playing = false

func _ready() -> void:
	checkpoint_pos_x = position.x
	checkpoint_pos_y = position.y
	# set the color with the level node
	var level_root = get_tree().root.find_child("level",true, false)
	current_color = level_root.starting_color
	checkpoint_color = current_color
	$AudioStreamPlayer2D.play(0.29)
	
func respawn():
	$AnimationPlayer.play("fadein")
	# call the level respawn 
	

func _physics_process(delta: float) -> void:
	if abs(velocity.x) > 0.1 and is_on_floor():
		if not walking_sound_playing:
			$AudioStreamPlayer2D.play()
			walking_sound_playing = true
	else:
		if walking_sound_playing:
			$AudioStreamPlayer2D.stop()
			walking_sound_playing = false
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")

	# Handle flipping
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	# Horizontal movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Animation logic
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif abs(velocity.x) > 0.1:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("default")
	
	move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadein":
		toggle_tilemap(checkpoint_color)
		await get_tree().process_frame
		position.x = checkpoint_pos_x
		position.y = checkpoint_pos_y
		# wait for 0.2s
		await get_tree().create_timer(0.3).timeout
		$AnimationPlayer.play("fadeout")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_platform"):
		print('changing the color from' + current_color)
		if current_color == "BLUE":
			current_color = "RED"
		else:
			current_color = "BLUE"
		toggle_tilemap(current_color)
			
func toggle_tilemap(color):
	print("toggling the tilemap color change")
	get_tree().root.find_child(color, true,false).show_tilemap()
	get_tree().root.find_child(color, true,false).collision_enabled = true
	get_tree().root.find_child(get_contrary_color(color), true,false).hide_tilemap()
	get_tree().root.find_child(get_contrary_color(color), true,false).collision_enabled = false
	
func get_contrary_color(color):
	if color == "RED":
		return "BLUE"
	else:
		return "RED"
		
func blink():
	$HUD.blink()
