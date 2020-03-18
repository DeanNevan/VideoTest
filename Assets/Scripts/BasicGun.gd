extends Node2D

var damage = 40
var capacity = 9
var ammo = 9
var accuracy = 0.8
var fire_rate = 0.9
var fire_range = 1000
var reload_time = 3
var bullet_speed = 800
var extra_bullet = 0

var reload_mode = 0

var basic_gun_offset = Vector2(22, 10)
var gun_offset = Vector2(22, 10)

var is_reloading = false
var is_cooling_down = false

var Bullet = preload("res://Guns/Bullet.tscn")
onready var CooldownTimer = Timer.new()
onready var ReloadTimer = Timer.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(CooldownTimer)
	CooldownTimer.one_shot = true
	CooldownTimer.connect("timeout", self ,"_on_CooldownTimer_timeout")
	add_child(ReloadTimer)
	ReloadTimer.one_shot = true
	ReloadTimer.connect("timeout", self ,"_on_ReloadTimer_timeout")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func cooldown():
	CooldownTimer.start(fire_rate)
	is_cooling_down = true
	pass

func reload():
	ReloadTimer.paused = false
	ReloadTimer.start(reload_time)
	is_reloading = true
	pass

func shoot(target_direction:Vector2, shoot_offset):
	if reload_mode == 1 and ammo > 0:
		ReloadTimer.paused = true
		pass
	elif is_cooling_down or is_reloading:
		return
	
	if ammo <= 0:
		reload()
	ammo -= 1
	for i in extra_bullet + 1:
		print("shoot!!")
		gun_offset = shoot_offset
		var new_bullet = Bullet.instance()
		var direction = target_direction.rotated(rand_range(accuracy - 1, 1 - accuracy) * PI / 2)
		Global.add_child(new_bullet)
		new_bullet.fly(global_position + gun_offset, direction, damage, bullet_speed, fire_range)
	cooldown()
	pass

func _on_CooldownTimer_timeout():
	print("cool_down")
	is_cooling_down = false
	pass

func _on_ReloadTimer_timeout():
	is_reloading = false
	if reload_mode == 0:
		ammo = capacity
	elif reload_mode == 1:
		ammo += 1
		if ammo < capacity:
			reload()
	pass
