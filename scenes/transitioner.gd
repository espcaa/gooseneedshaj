extends CanvasLayer

var new_scene : PackedScene

func change_to_scene_with_animation(scene : PackedScene):
	$AnimationPlayer.play("flush")
	new_scene = scene



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flush":
		get_tree().change_scene_to_packed(new_scene)
		$AnimationPlayer.play("reflush")
		
