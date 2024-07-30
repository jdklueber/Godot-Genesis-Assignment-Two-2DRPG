extends Node

signal hit(damage:int)

func take_damage(damage:int):
	print("HIT!")
	hit.emit(damage)
