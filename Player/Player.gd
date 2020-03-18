extends RigidBody2D

signal change_state(target_state)
signal change_gun(target_gun)

enum STATE{
	IDLE
	MOVING
	AIM
	RELOADING
}

var speed = 120
var max_life = 100
var life = 100

var gun
var gun_type

var state

# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE.IDLE
	gun = Global.Handgun.instance()
	add_child(gun)
	gun_type = Global.GUN_TYPE.HAND
	connect("change_state", self, "_on_change_state")
	pass # Replace with function body.

func _unhandled_input(event):
	if state != STATE.MOVING:
		if event.is_action_pressed("key_w") or event.is_action_pressed("key_a") or event.is_action_pressed("key_s") or event.is_action_pressed("key_d"):
			emit_signal("change_state", STATE.MOVING)
	if event.is_action_pressed("key_r"):
		emit_signal("change_state", STATE.RELOADING)
	if !gun.is_reloading:
		if event.is_action_pressed("left_mouse_button"):
			emit_signal("change_state", STATE.AIM)
			if is_instance_valid(gun):
				gun.shoot(get_global_mouse_position() - global_position, gun.basic_gun_offset.rotated($AnimatedSprite.global_rotation))
		if event.is_action_pressed("right_mouse_button"):
			emit_signal("change_state", STATE.AIM)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_object($AnimatedSprite, 10, (get_global_mouse_position() - global_position).normalized(), delta)
	match state:
		STATE.AIM:
			pass
		STATE.IDLE:
			pass
		STATE.MOVING:
			var velocity := Vector2()
			if Input.is_action_pressed("key_w"):
				velocity.y -= 1
			if Input.is_action_pressed("key_a"):
				velocity.x -= 1
			if Input.is_action_pressed("key_s"):
				velocity.y += 1
			if Input.is_action_pressed("key_d"):
				velocity.x += 1
			if velocity.length() > 0:
				linear_velocity = speed * velocity.normalized()
			elif velocity.length() == 0:
				emit_signal("change_state", STATE.IDLE)
			pass
		STATE.RELOADING:
			pass

func rotate_object(object, speed1, target_direction, delta):
	var present_direction = Vector2(1, 0).rotated(object.global_rotation)
	object.global_rotation = present_direction.linear_interpolate(target_direction, speed1 * delta).angle()

func _on_change_state(target_state):
	match target_state:
		STATE.AIM:
			match gun_type:
				Global.GUN_TYPE.HAND:
					$AnimatedSprite.animation = "gun"
				Global.GUN_TYPE.MACHINE:
					$AnimatedSprite.animation = "machine"
				Global.GUN_TYPE.SILENCER:
					$AnimatedSprite.animation = "silencer"
		STATE.IDLE:
			$AnimatedSprite.animation = "stand"
		STATE.MOVING:
			$AnimatedSprite.animation = "reload"
		STATE.RELOADING:
			$AnimatedSprite.animation = "reload"
	state = target_state
	pass
