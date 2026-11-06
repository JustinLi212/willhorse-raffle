extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.finish_race()
	$"..".send_positions(body.grab_id())
