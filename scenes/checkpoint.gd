extends Node2D

@export var ch_color : String = "RED"
var activated = false
var trbody : Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player" and !activated:
		$AnimatedSprite2D.play("open")
		activated = true
		trbody = body
		body.checkpoint_color = ch_color
		body.checkpoint_pos_x = position.x
		body.checkpoint_pos_y = position.y
		


func _on_animated_sprite_2d_animation_finished() -> void:
	if activated:
		trbody.blink()
