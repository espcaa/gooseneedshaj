extends TileMapLayer

func hide_tilemap():
	$AnimationPlayer.queue("hide")

func show_tilemap():
	$AnimationPlayer.queue("show")
