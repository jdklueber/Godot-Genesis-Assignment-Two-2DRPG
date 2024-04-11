extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var move_speed:float = 90

enum MODE {
	IDLE,
	CHASE,
	ATTACK
}


var is_attacking:bool = false
var state:MODE = MODE.IDLE
var target:Node2D = null
var movement_vector:Vector2 = Vector2.ZERO

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if target == null:
		target = get_tree().get_first_node_in_group("player")
		return
	
	movement_vector = target.global_position - global_position
	movement_vector = movement_vector.normalized()
	
	if not is_attacking:
		match state:
			MODE.IDLE:
				do_idle()
			MODE.CHASE:
				do_chase()
			MODE.ATTACK:
				do_attack()
	
	if movement_vector.x < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false
	
	move_and_slide()

func do_idle():
	velocity = Vector2.ZERO
	animation_player.play("idle")
	
func do_chase():
	animation_player.play("move")
	velocity = movement_vector * move_speed
	
func do_attack():
	velocity = Vector2.ZERO
	is_attacking = true
	animation_player.play("attack")


func _on_attack_field_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		state = MODE.ATTACK


func _on_attack_field_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		state = MODE.CHASE


func _on_chase_field_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		state = MODE.CHASE


func _on_chase_field_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		state = MODE.IDLE


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		is_attacking = false
