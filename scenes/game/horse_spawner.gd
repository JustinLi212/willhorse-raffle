class_name HorseSpawner
extends Node


const horse_scene = preload("uid://ddyvhgo0mateq")

var horse_images: Array[Texture2D] = [
	preload("uid://cg8fddt4blqgx"), 
	preload("uid://bauep1wcofm2q"), 
	preload("uid://cp1wl78k3bdca"), 
	preload("uid://bcbxvlprnwg0y"),
	preload("uid://cbsboumt8xlbo"), 
	preload("uid://poqkl4sjbrd"), 
	preload("uid://d3xaibwwa1rfe"), 
	preload("uid://bm4tdjnvqsja8")
]

var names: Array[String]
var horse_count: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parse_lines_from_txt("res://data/vgdc_fall_list.txt")
	horse_count = names.size()
	
	create_horses()


func create_horses() -> void:
	for i in horse_count:
		var horse := horse_scene.instantiate() as Horse
		horse.stats.horse_name = names.get(i)
		horse.stats.horse_image = horse_images.pick_random()
		horse.horse_id = i
		horse.scale = Vector2.ONE * 0.2
		horse.position = Vector2(15, randf_range(206, 630))
		add_child(horse)


func parse_lines_from_txt(file_path: String) -> void:
	var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return
	
	while not file.eof_reached():
		var line: String = file.get_line()
		line = line.strip_edges()
		names.append(line)
