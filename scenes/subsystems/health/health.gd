extends Node2D

signal on_health_updated(current_hp:int)
signal on_death

@export var max_hp:int = 1
var current_hp

func _ready() -> void:
	current_hp = max_hp

func take_damage(dmg:int) -> void:
	current_hp = clampi(current_hp - dmg, 0, max_hp)
	on_health_updated.emit(current_hp)
	
	if current_hp == 0:
		on_death.emit()


func heal(hup:int) -> void:
	current_hp = clampi(current_hp + hup, 0, max_hp)
	on_health_updated.emit(current_hp)
