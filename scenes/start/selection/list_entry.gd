class_name ListEntry
extends Panel

signal select_clicked
signal edit_clicked
signal delete_clicked
signal exploded

const SELECTED_WIDTH = 4
const UNSELECTED_WIDTH = 2

var data: ListData

var is_selected: bool:
	set(val):
		is_selected = val
		update_border()

@onready var name_label: Label = $MarginContainer/HBoxContainer/VBoxContainer/NameLabel
@onready var names_preview: Label = $MarginContainer/HBoxContainer/VBoxContainer/NamesPreview

@onready var animation_player: AnimationPlayer = $Explosions/Explosion/AnimationPlayer
@onready var explosion_sound: AudioStreamPlayer = $Explosions/ExplosionSound
@onready var explosions: Control = $Explosions
@onready var delete_button: Button = $MarginContainer/HBoxContainer/MarginContainer/HBoxContainer/DeleteButton


func _ready() -> void:
	setup()


func setup() -> void:
	name_label.text = data.list_name
	var file: FileAccess = FileAccess.open(data.list_file_path, FileAccess.READ)
	if file == null:
		push_error("File missing.")
		return
	names_preview.text = ", ".join(file.get_as_text().split("\n"))


func _on_select_button_pressed() -> void:
	select_clicked.emit()


func _on_delete_button_pressed() -> void:
	delete_button.disabled = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.6)
	delete_clicked.emit()
	explosions.show()
	animation_player.play("explode")
	explosion_sound.play()
	await animation_player.animation_finished
	exploded.emit()


func _on_edit_button_pressed() -> void:
	edit_clicked.emit()

func update_border() -> void:
	var stylebox: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	stylebox.border_width_left = SELECTED_WIDTH if is_selected else UNSELECTED_WIDTH
	stylebox.border_width_top = SELECTED_WIDTH if is_selected else UNSELECTED_WIDTH
	stylebox.border_width_right = SELECTED_WIDTH if is_selected else UNSELECTED_WIDTH
	stylebox.border_width_bottom = SELECTED_WIDTH if is_selected else UNSELECTED_WIDTH
	stylebox.border_color = Color.WHITE if is_selected else Color.WEB_GRAY
	add_theme_stylebox_override("panel", stylebox)
