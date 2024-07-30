extends Area2D

@export var target_group:String
@export var damage:int = 1

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hitbox") and area.get_parent().is_in_group(target_group):
		area.take_damage(damage)
