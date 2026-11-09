class_name HorseStats
extends Resource


@export var horse_name: String = "Will"
@export var horse_image: Texture2D = preload("uid://bauep1wcofm2q")

## Horse's explosion chance, represented by a percentage.
## Should be between 0 and 1.
@export var explosion_chance: float = 0.2

## Time in milliseconds that this horse completed the race in.
## If DNF, this value is -1.
@export var finish_time_ms: int

@export var time_exploded_ms: int = -1

## Placement of this horse. This is 1-indexed, so 0 means the horse didn't finish.
@export var placement: int
