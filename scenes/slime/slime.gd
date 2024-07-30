extends CharacterBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var move_speed:float = 80
@export var sight_radius:float = 100
@export var attack_radius:float = 40
@export var attack_cooldown:float = .2
@onready var sight_shape: CollisionShape2D = $ChaseField/CollisionShape2D
@onready var attack_shape: CollisionShape2D = $AttackField/CollisionShape2D
@onready var attack_timer: Timer = $AttackTimer
@onready var health: Node2D = $Health

enum MODE {
	IDLE,
	CHASE,
	ATTACK
}


var state:MODE = MODE.IDLE
var target:Node2D = null
var movement_vector:Vector2 = Vector2.ZERO
var is_attacking:bool = false

func _ready() -> void:
	target = get_tree().get_first_node_in_group("player")
	set_radii()


func _physics_process(delta: float) -> void:
	if target == null:
		target = get_tree().get_first_node_in_group("player")
		return
	
	movement_vector = target.global_position - global_position
	movement_vector = movement_vector.normalized()
		
	if !is_attacking:
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
	attack_animation()
	
func attack_animation():
	var tween = create_tween()
	var current_pos = global_position
	tween.tween_callback(animation_player.play.bind("attack")) 
	tween.tween_property(self, "global_position", target.global_position, .5)
	tween.tween_property(self, "global_position", current_pos, .5)
	tween.tween_callback(reset_is_attacking).set_delay(attack_cooldown)
	

func reset_is_attacking():
	is_attacking = false

func set_radii():
	attack_shape.shape.radius = attack_radius
	sight_shape.shape.radius = sight_radius

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


func _on_health_on_death() -> void:
	animation_player.play("death")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()


func _on_hitbox_hit(damage: int) -> void:
	health.take_damage(damage)
