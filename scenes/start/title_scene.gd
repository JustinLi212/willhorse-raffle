extends Node

@onready var button: Button = $Button
@export_file("*.tscn") var racing_scene: String = "uid://bsflhckys32y4"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(racing_scene)
