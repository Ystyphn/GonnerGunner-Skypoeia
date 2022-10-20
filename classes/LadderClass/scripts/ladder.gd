class_name LadderClass
extends Node2D

func _ready() -> void:
	$LadderArea.connect("body_entered", self, "body_entered")
	$LadderArea.connect("body_exited", self, "body_exited")

func body_entered(body):
	body.on_ladder_area = true
	body.ladder = self

func body_exited(body):
	body.on_ladder_area = false
	body.ladder = self
