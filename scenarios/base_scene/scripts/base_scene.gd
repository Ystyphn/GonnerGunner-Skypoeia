class_name BaseScene
extends Node2D


export (NodePath) var tilemap_path
export (NodePath) var buildings_node_path
export (NodePath) var ships_node_path
export (NodePath) var entities_node_path
export (NodePath) var projectiles_node_path
export (NodePath) var effects_path
export (NodePath) var collectibles_path

onready var tilemap: TileMap = get_node(tilemap_path)
onready var buildings_node: Node2D = get_node(buildings_node_path)
onready var ships_node: Node2D = get_node(ships_node_path)
onready var entities_node: Node2D = get_node(entities_node_path)
onready var projectiles_node: Node2D = get_node(projectiles_node_path)
onready var effects_node: Node2D = get_node(effects_path)
onready var collectibles_node: Node2D = get_node(collectibles_path)

func _ready():
	Globals.game_scene = self
