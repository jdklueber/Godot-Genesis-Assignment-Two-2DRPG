extends CharacterBody2D

@export var move_speed:float = 100
@onready var animation_tree: AnimationTree = $AnimationTree

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
	print(anim_name)
	if anim_name.begins_with("attack"):
		attacking = false

