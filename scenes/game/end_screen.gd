extends Panel

const standing_scene = preload("uid://yywyvjdj5f74")
@export_file("*.tscn") var title_screen = "uid://dim6p6luhy7bo"

var winners: Array[Horse]
var exploded_horses: Array[Horse]

@onready var standing_container: VBoxContainer = $ScrollContainer/StandingContainer
@onready var winning_horse: Sprite2D = $WinningHorse

func _ready() -> void:
	EventBus.race_ended.connect(display_standings)

func display_standings() -> void:
	winning_horse.texture = winners.get(0).stats.horse_image
	
	for standing in standing_container.get_children():
		standing.queue_free()
	
	for winner in winners:
		var new_standing := standing_scene.instantiate() as Standing
		new_standing.stats = winner.stats
		standing_container.add_child(new_standing)
	
	for exploded_horse in exploded_horses:
		var new_standing := standing_scene.instantiate() as Standing
		new_standing.stats = exploded_horse.stats
		standing_container.add_child(new_standing)


func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_file(title_screen)
