extends Node2D


enum {
	PLAYER,
	SHIP}
enum {
	STOP,
	SHOOTING,
	MOVING}

var critical_height: bool = false  # this became true if the raycast is colliding

onready var round_copter: KinematicBody2D = get_parent()

