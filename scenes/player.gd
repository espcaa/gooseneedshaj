extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var checkpoint_pos_y : float
var checkpoint_pos_x : float

func _ready() -> void:
	checkpoint_pos_x = position.x
	checkpoint_pos_y = position.y
	
func respawn():
	$AnimationPlayer.play("fadein")

func _physics_process(delta: float) -> void:
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
		position.x = checkpoint_pos_x
		position.y = checkpoint_pos_y
		# wait for 0.1s
		await get_tree().create_timer(0.3).timeout
		$AnimationPlayer.play("fadeout")
