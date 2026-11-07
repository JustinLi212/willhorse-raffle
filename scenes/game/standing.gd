class_name Standing
extends Panel

@export var stats: HorseStats

@onready var horse_texture: TextureRect = $MarginContainer/HBoxContainer/HorseTexture
@onready var place_and_name: Label = $MarginContainer/HBoxContainer/PlaceAndName
@onready var time: Label = $MarginContainer/HBoxContainer/Time


func _ready() -> void:
	setup()

func setup() -> void:
	horse_texture.texture = stats.horse_image
	if stats.placement > 0:
		place_and_name.text = "%d. %s" % [stats.placement, stats.horse_name]
	else:
		place_and_name.text = "DNF: %s" % stats.horse_name
	if stats.finish_time_ms > 0:
		time.text = convert_ms_to_time_string(stats.finish_time_ms)
	else:
		time.text = "-"

static func convert_ms_to_time_string(time_ms: int) -> String:
	@warning_ignore_start("integer_division")
	var ms := time_ms % 1000
	var sec := (time_ms / 1000) % 60
	var mins := time_ms / 60_000
	return "%02d:%02d:%03d" % [mins, sec, ms]
