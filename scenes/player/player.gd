extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

@export var move_speed:float = 100

func _physics_process(delta: float) -> void:
	velocity.x = Input.get_axis("left", "right")
	velocity.y = Input.get_axis("up", "down")
	
	velocity *= move_speed
	
	move_and_slide()
