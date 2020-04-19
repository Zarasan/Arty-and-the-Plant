extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var isNight = false
var timer = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	isNight = false
	timer = 4
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):
	print(delta)
	
	pass
