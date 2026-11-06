class_name Horse
extends Node2D

signal horse_exploded
signal horse_won

const MIN_SPEED: float = 2.0
const MAX_SPEED: float = 8.0

var explosion_chance: float = 0.20
var run_timer: float = 0.0

@export var speed: float = 5.0
@export var horse_id: int = 0

@onready var horse_sprite: Sprite2D = $HorseSprite
@onready var explosion: AnimatedSprite2D = $Explosion
@onready var panel: Panel = $Panel
@onready var name_label: Label = $Panel/NameLabel
@onready var finish_raycast: RayCast2D = $FinishRaycast
@onready var speed_change_timer: Timer = $SpeedChangeTimer


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

var stats: HorseStats = HorseStats.new()

var step_size = 10
var queued_to_explode: bool = false
var has_exploded: bool = false
var is_racing: bool = false
var explosion_x: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.race_started.connect(start_racing)
	explosion.visible = false
	horse_sprite.texture = horse_images.pick_random()
	name_label.text = stats.horse_name

## Called by RaceManager, guarantees that the horse will explode at explosion_x
func will_explode():
	queued_to_explode = true
	explosion_x = randi_range(200, 900)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	run_timer += delta * speed
	if is_racing:
		position.x += delta * speed * step_size
		horse_sprite.rotation_degrees = sin(PI * run_timer) * 8
		if queued_to_explode and position.x > explosion_x:
			finish_race()
			explode()
		if finish_raycast.is_colliding():
			finish_race()
	else:
		horse_sprite.rotation_degrees = 0
	
func start_racing() -> void:
	is_racing = true
	randomize_speed()
	speed_change_timer.start()
	
func finish_race() -> void:
	if not has_exploded:
		horse_won.emit()
	is_racing = false
	speed_change_timer.stop()

func explode():
	horse_sprite.visible = false
	panel.visible = false
	
	has_exploded = true
	explosion.visible = true
	AudioManager.play_explosion()
	speed_change_timer.stop()
	explosion.play()
	await explosion.animation_finished
	explosion.visible = false
	horse_exploded.emit()


func randomize_speed() -> void:
	if has_exploded:
		return
	speed = randf_range(MIN_SPEED, MAX_SPEED)
	speed_change_timer.wait_time = randf_range(2.0, 5.0)
	maybe_explode()


func maybe_explode() -> void:
	if randf() < explosion_chance:
		explode()
