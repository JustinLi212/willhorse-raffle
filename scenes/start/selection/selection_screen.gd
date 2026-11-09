extends Node

const LIST_ENTRY = preload("uid://wkfaugk8f20y")

@export_file var race_scene: String = "uid://bn0taqd66rbb4"

enum Delimiter {
	NEW_LINE,
	COMMA,
	SEMICOLON,
	SPACE
}

var is_list_selected: bool = false
var list_to_edit: ListData

@onready var list_entries: VBoxContainer = %ListEntries
@onready var new_list_edit: LineEdit = %NewListEdit
@onready var next_button: TextureButton = $NextButton
@onready var list_menu: MarginContainer = %ListMenu
@onready var edit_menu: MarginContainer = %EditMenu

@onready var title_edit: LineEdit = $TabContainer/ListSettings/EditMenu/VBoxContainer/HBoxContainer/TitleEdit
@onready var option_button: OptionButton = $TabContainer/ListSettings/EditMenu/VBoxContainer/HBoxContainer/OptionButton
@onready var text_edit: TextEdit = $TabContainer/ListSettings/EditMenu/VBoxContainer/TextEdit


func _ready() -> void:
	refresh_lists()


func _on_next_button_pressed() -> void:
	if not is_list_selected:
		return
	get_tree().change_scene_to_file(race_scene)


func _on_create_button_pressed() -> void:
	var file_name := ListManager.create_or_get_list(new_list_edit.text)
	
	for list in ListManager.list_entries.lists:
		if list.list_file_path == file_name:
			return
	
	var data: ListData = ListData.new()
	data.list_name = new_list_edit.text
	data.list_file_path = file_name
	
	GameManager.current_data = data
	is_list_selected = true
	
	ListManager.add_list(data)
	refresh_lists()
	new_list_edit.text = ""
	ListManager.save_lists()


func _on_select_clicked(list_entry: ListEntry) -> void:
	print("Selecting list %s" % list_entry.data.list_name)
	
	GameManager.current_data = list_entry.data
	is_list_selected = true
	
	refresh_lists()


func _on_edit_clicked(list_entry: ListEntry) -> void:
	print("Editing list %s" % list_entry.data.list_name)
	list_to_edit = list_entry.data
	list_menu.visible = false
	update_edit_menu()
	edit_menu.visible = true
	refresh_lists()


func _on_delete_clicked(list_entry: ListEntry) -> void:
	print("Deleting list %s" % list_entry.data.list_name)
	ListManager.remove_list(list_entry.data)
	ListManager.save_lists()
	await list_entry.exploded
	refresh_lists()


func _create_entry_from_data(data: ListData) -> void:
	var new_entry: ListEntry = LIST_ENTRY.instantiate()
	new_entry.select_clicked.connect(_on_select_clicked, CONNECT_APPEND_SOURCE_OBJECT)
	new_entry.edit_clicked.connect(_on_edit_clicked, CONNECT_APPEND_SOURCE_OBJECT)
	new_entry.delete_clicked.connect(_on_delete_clicked, CONNECT_APPEND_SOURCE_OBJECT)
	new_entry.data = data
	list_entries.add_child(new_entry)


func refresh_lists() -> void:
	for entry in list_entries.get_children():
		entry.queue_free()
	for data in ListManager.list_entries.lists:
		_create_entry_from_data(data)
	if not (GameManager.current_data and 
			GameManager.current_data in ListManager.list_entries.lists):
		select_first_list()
	update_is_selected_variable()


func select_first_list() -> void:
	if list_entries.get_child_count() > 0:
		GameManager.current_data = list_entries.get_child(0).data
		is_list_selected = true


func update_edit_menu() -> void:
	var file := FileAccess.open(list_to_edit.list_file_path, FileAccess.READ_WRITE)
	if not file:
		push_warning("Something went wrong retrieving the list file.")
		return
	
	title_edit.text = list_to_edit.list_name
	text_edit.text = file.get_as_text()
	match list_to_edit.list_delimiter:
		"\n": option_button.select(Delimiter.NEW_LINE)
		",": option_button.select(Delimiter.COMMA)
		";": option_button.select(Delimiter.SEMICOLON)
		" ": option_button.select(Delimiter.SPACE)


func _on_save_button_pressed() -> void:
	var file: FileAccess = FileAccess.open(list_to_edit.list_file_path, FileAccess.WRITE)
	file.store_string(text_edit.text)
	file.close()
	list_to_edit.list_name = title_edit.text
	ListManager.save_lists()
	refresh_lists()
	list_menu.visible = true
	edit_menu.visible = false


func _on_cancel_button_pressed() -> void:
	list_menu.visible = true
	edit_menu.visible = false


func update_is_selected_variable() -> void:
	for entry in list_entries.get_children():
		if entry.data == GameManager.current_data:
			entry.is_selected = true
		else:
			entry.is_selected = false
