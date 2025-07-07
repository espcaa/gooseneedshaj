extends Control

var sceneaa : PackedScene

func change_to_scene_with_animation(scene : PackedScene):
	$AnimationPlayer.play("flush")
	sceneaa = scene



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flush":
		get_tree().change_scene_to_packed(sceneaa)
		$AnimationPlayer.play("reflush")
		
