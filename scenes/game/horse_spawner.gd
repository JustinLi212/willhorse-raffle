extends Node

signal horse_won(id: int)

const horse_scene = preload("uid://ddyvhgo0mateq")

var names: Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parse_lines_from_txt("res://data/vgdc_fall_list.txt")
	for i in names.size():
		var horse := horse_scene.instantiate() as Horse
		horse.stats.horse_name = names.get(i)
		horse.horse_id = i
		horse.scale = Vector2.ONE * 0.2
		horse.position = Vector2(15, randf_range(206, 630))
		horse.horse_won.connect(_on_horse_won, CONNECT_APPEND_SOURCE_OBJECT)
		add_child(horse)


func parse_lines_from_txt(file_path: String) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return
	
	while not file.eof_reached():
		var line: String = file.get_line()
		line = line.strip_edges()
		names.append(line)


func _on_horse_won(horse: Horse) -> void:
	horse_won.emit(horse)
