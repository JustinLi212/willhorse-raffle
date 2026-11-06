extends Node


var places: Array[Horse]

@onready var horse_run_audio: AudioStreamPlayer = $HorseRunAudio
@onready var horse_spawner: Node = $HorseSpawner


func _ready() -> void:
	horse_spawner.horse_won.connect(_on_horse_won)


func start_race() -> void:
	EventBus.race_started.emit()
	horse_run_audio.play()


func _on_horse_won(horse: Horse) -> void:
	places.append(horse)
	if places.size() <= 3:
		print("Place %d: %s" % [places.size(), horse.stats.horse_name])
