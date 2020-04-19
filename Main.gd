extends Spatial

var Robot_Energy

var Plant_Health
var Plant_Sunlight
var Plant_Water


var plant_hidden = false
var plant_watering
var daytimer = 40
var isNight = false
var nightPower = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Robot_Energy = 100
	Plant_Health = 100
	Plant_Water = 100
	Plant_Sunlight = 80
	plant_hidden = false
	plant_watering = false
	isNight = false
	nightPower = 1
	pass # Replace with function body.


func rangeAmount(value, minimum, maximum):
	if value > maximum:
		value = maximum
	if value < minimum:
		value = minimum
	return value
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	nightPower += delta
	if nightPower > 1:
		nightPower = 1
	if !isNight:
		get_node("WorldEnvironment").environment.background_energy = lerp(.1, 1, nightPower)
		daytimer -= delta
	else:
		daytimer += delta
		get_node("WorldEnvironment").environment.background_energy = lerp(1, .1, nightPower)
	if daytimer < 0:
		nightPower = 0
		isNight = true
	if daytimer > 40:
		nightPower = 0
		isNight = false
	
	Plant_Water = rangeAmount(Plant_Water, 0, 102)
	Plant_Sunlight = rangeAmount(Plant_Sunlight, 0, 101)
	Plant_Health = rangeAmount(Plant_Health, 0, 100)
	Robot_Energy = rangeAmount(Robot_Energy, 0, 100)
	#Updater	
	if plant_watering and !plant_hidden:
		Plant_Water += .1
		$"Character/Particles".emitting = true
	else:
		$"Character/Particles".emitting = false
		Plant_Water -= delta
		
	if plant_hidden or get_node("SandStorm").is_Storm or isNight:
		Plant_Sunlight -= delta
	else:
		Plant_Sunlight += delta*1.5
		
	#Checker
	if !isNight:
		Robot_Energy += delta*2
		
	
	if get_node("SandStorm").is_Storm:
		if !get_node("Character").robot_hidden:
			if !plant_hidden:
				Plant_Health -= delta*2
	
	if Plant_Sunlight > 90:
		$"UI/Notifications/Sunlight".visible = true
		Plant_Health -= delta
	else:
		$"UI/Notifications/Sunlight".visible = false
		
	if Plant_Water > 90:
		Plant_Health += delta
	
	if Plant_Sunlight < 10:
		$"UI/Notifications/Sunlight2".visible = true
	else:
		$"UI/Notifications/Sunlight2".visible = false
		
	if Plant_Water < 10:
		$"UI/Notifications/Water".visible = true
	else:
		$"UI/Notifications/Water".visible = false
		
	
	if Plant_Sunlight < 1 or Plant_Water < 1:
		Plant_Health -= delta*2
		
	#Value Matcher
	$"UI/Robot/Robot Energy".value = Robot_Energy
	$"UI/Plant/Plant_Health".value = Plant_Health
	$"UI/Plant/Plant_Water".value = Plant_Water
	$"UI/Plant/Plant_Sunlight".value = Plant_Sunlight
	pass


func _on_Area2_body_entered(body):
	get_tree().change_scene("res://EndScene.tscn")
	pass # Replace with function body.
