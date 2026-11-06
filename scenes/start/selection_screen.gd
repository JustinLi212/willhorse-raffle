extends Node


@export_file var race_scene: String = "uid://bn0taqd66rbb4"

var is_list_selected: bool = true

@onready var next_button: TextureButton = $NextButton


func _on_next_button_pressed() -> void:
	if not is_list_selected:
		return
	get_tree().change_scene_to_file(race_scene)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("continue"):
		_on_next_button_pressed()
