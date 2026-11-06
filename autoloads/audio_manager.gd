extends Node

@onready var explosion_player: AudioStreamPlayer = $ExplosionPlayer


func play_explosion() -> void:
	explosion_player.play()
