extends Area2D

enum State { UNBUMPED, BUMPED }
var state: int = State.UNBUMPED
var original_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position
	
# Signal handler for body_entered
func _on_body_entered(body):
	if body.is_in_group("Player") and state == State.UNBUMPED:
		bump_block()
	
# Logic for Block Bumping	
func bump_block():
	state = State.BUMPED
	$Sprite2D.frame = 1 	# Switch to the second frame to indicate used state
	Global.spawn_powerup(self.global_position + Vector2(0, -20))
	bump_upwards()
	var timer = get_tree().create_timer(0.2)
	await timer.timeout
	return_to_original_position()

# Function to Move the Block
func bump_upwards():
	position.y -= 10

# Function to return the block to it's original position
func return_to_original_position():
	position = original_position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
