extends Spatial

var timer = 10
var is_Storm
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var canStorm = false
var fogPower = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if canStorm:
		get_parent().get_node("UI/Notifications/Storm").text = "Storm in: %2ds. Hide!" % timer
		get_node(".").translation = get_parent().get_node("Character").translation
		if Input.is_action_just_pressed("ui_focus_next") and !is_Storm:
			beginStorm()
		timer -= delta
		if is_Storm:
			fogPower += delta
			if fogPower > 1:
				fogPower = 1
			get_node("Particles").amount = lerp(100,600,fogPower)
			get_parent().get_node("WorldEnvironment").environment.fog_depth_begin = lerp(50,2,fogPower)
			get_parent().get_node("WorldEnvironment").environment.fog_depth_end = lerp(100,10,fogPower)
			if timer < 0:
				endStorm()
		else:
			fogPower = 0
			if timer < 0:
				beginStorm()
	pass
	
func beginStorm():
	get_parent().get_node("UI/Notifications/Storm").visible = false
	is_Storm = true
	get_node("Particles").emitting = true
	get_parent().get_node("WorldEnvironment").environment.fog_enabled = true
	timer = 15
	pass
	
func endStorm():
	get_parent().get_node("UI/Notifications/Storm").visible = true
	is_Storm = false
	get_node("Particles").emitting = false
	get_parent().get_node("WorldEnvironment").environment.fog_enabled = false
	timer = 10
	pass


func _on_Area_body_entered(body):
	canStorm = true
	get_parent().get_node("UI/Notifications/Storm").visible = true
	pass # Replace with function body.
