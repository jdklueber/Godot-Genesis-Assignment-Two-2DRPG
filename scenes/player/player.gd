extends CharacterBody2D

@export var move_speed:float = 100
@export var attack_damage:int = 1
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var health: Node2D = $Health


var attacking:bool = false

func _physics_process(delta: float) -> void:
	velocity.x = Input.get_axis("left", "right")
	velocity.y = Input.get_axis("up", "down")
	
	velocity *= move_speed
	
	if Input.is_action_just_pressed("attack"):
		animation_tree.get("parameters/playback").travel("Attack")
		attacking = true
	elif velocity != Vector2.ZERO && not attacking:
		animation_tree.set("parameters/Idle/blend_position", velocity)
		animation_tree.set("parameters/Walk/blend_position", velocity)
		animation_tree.set("parameters/Attack/blend_position", velocity)

		animation_tree.get("parameters/playback").travel("Walk")
	elif not attacking:
		animation_tree.get("parameters/playback").travel("Idle")

	move_and_slide()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("attack"):
		attacking = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if attacking and area.is_in_group("hitbox") and area.get_parent().is_in_group("enemy"):
		area.take_damage(attack_damage)


func _on_hitbox_hit(damage: int) -> void:
	health.take_damage(damage)


func _on_health_on_health_updated(current_hp: int) -> void:
	print("OW!!  Current Health: " + str(current_hp))


func _on_health_on_death() -> void:
	queue_free()
