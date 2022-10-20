extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerUi.get_node("playerUI").set_visible(false)
	Globals.fade_out()

func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
