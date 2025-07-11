extends Node2D
@export var starting_color = "RED"


func _ready() -> void:
	$AnimationPlayer.play("pulse")
	$BLUE.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("change_platform"):
		$AnimationPlayer.play("disapear")

func player_respawned():
	$AnimationPlayer.play("pulse")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "disapear" and $Sprite2D:
		$Sprite2D.queue_free()
