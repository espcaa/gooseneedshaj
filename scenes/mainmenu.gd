extends Control

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	$AnimationPlayer.play("enter")


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_button_2_pressed() -> void:
	Transitioner.change_to_scene_with_animation(load("res://scenes/level_1.tscn"))
