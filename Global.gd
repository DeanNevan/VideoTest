extends Node

enum BODY_TYPE{
	PLAYER
	ENEMY
	NPC
	WALL
}
enum GUN_TYPE{
	HAND
	MACHINE
	SILENCER
}

var Handgun = preload("res://Guns/Handgun.tscn")
var Machine
var Silencer 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
