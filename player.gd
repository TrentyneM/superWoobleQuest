extends CharacterBody2D

var is_dying = false;

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var death_timer = $death_timer

func _ready():
	add_to_group("Player")
	death_timer.connect("timeout", Callable(self, "_on_DeathTimer_timeout"))

func _physics_process(delta: float) -> void:
	if is_dying:
		return
		
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy") and body.is_alive:
		die()
		
func die():
	if is_dying:
		return
		
	is_dying = true
	await move_player_up_and_down()
	Global.player_lives -= 1
	
	if Global.player_lives > 0:
		print("Reloading Scene")
		get_tree().reload_current_scene()
	else:
		queue_free()
		get_tree().change_scene_to_file("res://gameover.tscn")

func move_player_up_and_down():
	var start_position = position
	var up_position = start_position + Vector2(0, -100)
	var down_position = start_position + Vector2(0, 600)
	
	while position.y > up_position.y:
		position.y -= 4
		await get_tree().create_timer(0.01).timeout

	while position.y < down_position.y:
		position.y += 4
		await get_tree().create_timer(0.01).timeout
	
func on_DeathTimer_timeout():
	get_tree().reload_current_scene()
