extends RigidBody2D

var start_position
var direction
var damage
var speed
var fly_range

var tail_size = 20
var tail_width = 5
var tail_color = Color.white

var WakeFlame
# Called when the node enters the scene tree for the first time.
func _ready():
	WakeFlame = load("res://Assets/SpecialEffect/WakeFlame.tscn").instance()
	WakeFlame.user = self
	WakeFlame.tail_size = tail_size
	WakeFlame.color = tail_color
	WakeFlame.width = tail_width
	Global.add_child(WakeFlame)
	linear_damp = 0.2
	connect("body_entered", self, "_on_body_entered")
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (global_position - start_position).length() > fly_range:
		queue_free()
	pass

func fly(start_position1, target_direction, damage1, bullet_speed, fire_range):
	start_position = start_position1
	global_position = start_position
	direction = target_direction
	damage = damage1
	speed = bullet_speed
	fly_range = fire_range
	linear_velocity = target_direction.normalized() * speed
	pass

func _on_body_entered(body):
	if is_instance_valid(body):
		if body.has_method("get_damage"):
			body.get_damage(damage)
		queue_free()
