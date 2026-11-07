extends Node


var winners: Array[Horse]
var exploded_horses: Array[Horse]

var is_race_running: bool:
	set(val):
		is_race_running = val
		if is_race_running:
			horse_run_audio.play()
		else:
			horse_run_audio.stop()

@onready var horse_run_audio: AudioStreamPlayer = $HorseRunAudio
@onready var horse_spawner: HorseSpawner = $HorseSpawner
@onready var end_screen: Panel = $UI/EndScreen

func _ready() -> void:
	horse_spawner.horse_won.connect(_on_horse_won)
	horse_spawner.horse_exploded.connect(_on_horse_exploded)


func start_race() -> void:
	EventBus.race_started.emit()
	is_race_running = true


func _on_horse_won(horse: Horse) -> void:
	winners.append(horse)
	if winners.size() <= 3:
		print("Place %d: %s" % [winners.size(), horse.stats.horse_name])
	check_race_state()


func _on_horse_exploded(horse: Horse) -> void:
	exploded_horses.append(horse)
	check_race_state()


func check_race_state() -> void:
	if winners.size() + exploded_horses.size() == \
			horse_spawner.horse_count:
		is_race_running = false
		print("Race over")
		show_end_screen()

func show_end_screen() -> void:
	end_screen.show()
