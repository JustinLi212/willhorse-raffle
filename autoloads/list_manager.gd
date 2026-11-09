extends Node


const list_folder_path: String = "user://name_lists"
const list_entries_path: String = "user://list_entries.tres"

var dir: DirAccess
var list_entries: GlobalListEntries


func _ready() -> void:
	_verify_lists_folder()
	load_lists()

func load_lists() -> void:
	if ResourceLoader.exists(list_entries_path):
		list_entries = load(list_entries_path)
	else:
		list_entries = GlobalListEntries.new()

func save_lists() -> void:
	if not list_entries_path:
		return
	ResourceSaver.save(list_entries, list_entries_path)

func add_list(list_data: ListData) -> void:
	list_entries.lists.append(list_data)

func remove_list(list_data: ListData) -> void:
	list_entries.lists.erase(list_data)
	OS.move_to_trash(ProjectSettings.globalize_path(list_data.list_file_path))

func _verify_lists_folder() -> void:
	if not DirAccess.dir_exists_absolute(list_folder_path):
		DirAccess.make_dir_absolute(list_folder_path)
	dir = DirAccess.open(list_folder_path)

func create_or_get_list(list_name: String) -> String:
	var file_name: String = list_name.to_snake_case() + ".txt"
	var path_name: String = list_folder_path.path_join(file_name)
	if not dir.file_exists(file_name):
		FileAccess.open(path_name, FileAccess.WRITE)
	return path_name

func delete_list(list_data: ListData) -> void:
	OS.move_to_trash(ProjectSettings.globalize_path(list_data.list_file_path))
