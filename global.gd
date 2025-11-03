extends Node

var total_coins = 0
var player_lives = 3

# Global.spawn_powerup(self.global_position + Vector2(0, -
func spawn_powerup(pos):
	var powerupScene = load("res://powerup.tscn")
	var power_up = powerupScene.instantiate()
	power_up.global_position = pos
	get_tree().root.add_child(power_up)
