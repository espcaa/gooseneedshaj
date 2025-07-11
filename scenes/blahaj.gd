extends Node2D

var targetting = false
var tracking_body : Node2D
const SPEED = 200
@export var next_level : PackedScene

# This is a very bad script and won't work if the player isn't in the scene
# -> Please use the tilemap one if it isn't in a level

func _process(delta: float) -> void:
	if targetting:
		position = position.move_toward(Vector2(tracking_body.position.x, tracking_body.position.y-140), delta * SPEED)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if not targetting:
	# Make it go up slowly to the center of the player's screen...
			tracking_body = body
			targetting = true
			$AnimationPlayer.play("collection")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	Transitioner.change_to_scene_with_animation(next_level)
