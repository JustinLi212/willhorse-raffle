extends Node


const list_folder_path: String = "user://lists"

func _ready() -> void:
	_verify_lists_folder()

func _verify_lists_folder() -> void:
	if not DirAccess.dir_exists_absolute(list_folder_path):
		DirAccess.make_dir_absolute(list_folder_path)
