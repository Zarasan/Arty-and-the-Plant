extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var water_nearby = false
var robot_hidden = false

var gravity = Vector3.DOWN * 12
var speed = 12
var jump_speed = 6
var spin = 0.1
var velocity = Vector3()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity += gravity * delta
	if get_parent().Robot_Energy > 1:
		get_input(delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	pass

func get_input(delta):
	if get_parent().get_node("SandStorm").is_Storm:
		speed = 6
	else:
		speed = 12
	var vy = velocity.y
	velocity = Vector3()
	if Input.is_action_pressed("forward"):
		get_parent().Robot_Energy -= delta
		velocity += transform.basis.z * speed
	if Input.is_action_pressed("backwards"):
		get_parent().Robot_Energy -= delta
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed("left"):
		get_parent().Robot_Energy -= delta
		velocity += transform.basis.x * speed
	if Input.is_action_pressed("right"):
		get_parent().Robot_Energy -= delta
		velocity += -transform.basis.x * speed
	velocity.y = vy
	
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y += jump_speed
	
	if Input.is_action_just_pressed("hide"):
		get_parent().plant_hidden = !get_parent().plant_hidden
		$Plant.visible = !get_parent().plant_hidden
	if Input.is_action_pressed("water_plant") and water_nearby:
		get_parent().plant_watering = true
	if Input.is_action_just_released("water_plant") or !water_nearby:
		get_parent().plant_watering = false
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-lerp(0,spin, event.relative.x/10))
	pass

func _on_Water_body_entered(_body):
	$"../UI/Notifications/Watering_Place".visible = true
	water_nearby = true
	pass # Replace with function body.


func _on_Water1_body_exited(_body):
	$"../UI/Notifications/Watering_Place".visible = false
	water_nearby = false
	pass # Replace with function body.

func _on_Cover_body_entered(_body):
	robot_hidden = true
	pass # Replace with function body.


func _on_Cover_body_exited(_body):
	robot_hidden = false
	pass # Replace with function body.
