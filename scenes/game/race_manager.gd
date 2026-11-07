extends Node


var winners: Array[Horse]
var exploded_horses: Array[Horse]

@onready var horse_run_audio: AudioStreamPlayer = $HorseRunAudio
@onready var horse_spawner: HorseSpawner = $HorseSpawner
@onready var end_screen: Panel = $UI/EndScreen
@onready var horse_victory_audio: AudioStreamPlayer = $HorseVictoryAudio

func _ready() -> void:
	EventBus.horse_won.connect(_on_horse_won)
	EventBus.horse_exploded.connect(_on_horse_exploded)
	EventBus.race_ended.connect(_on_race_ended)
	
	# They can share the same array why not what could go wrong
	end_screen.winners = winners
	end_screen.exploded_horses = exploded_horses


func start_race() -> void:
	EventBus.race_started.emit()
	horse_run_audio.play()


func _on_horse_won(horse: Horse) -> void:
	winners.append(horse)
	horse.stats.placement = winners.size()
	if winners.size() <= 3:
		print("Place %d: %s" % [winners.size(), horse.stats.horse_name])
	check_race_state()


func _on_horse_exploded(horse: Horse) -> void:
	exploded_horses.append(horse)
	check_race_state()


func check_race_state() -> void:
	if winners.size() + exploded_horses.size() == \
			horse_spawner.horse_count:
		EventBus.race_ended.emit()

func _on_race_ended() -> void:
	print("Race over")
	horse_run_audio.stop()
	horse_victory_audio.play()
	for loser in exploded_horses:
		loser.stats.placement = winners.size() + 1
	show_end_screen()

func show_end_screen() -> void:
	end_screen.show()
