extends Node2D

var current_age
var current_level
var levels = [1,2,3,4,5,6]
var times = ['04:00am', "08:00am", "12:00am", "16:00am", "20:00am", "00:00am"]
@export var gradient:GradientTexture1D
var gradients = []

var time:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	current_age="child"
	current_level=1
	gradients = [gradient.gradient.sample(0.2), gradient.gradient.sample(0.4), gradient.gradient.sample(1), gradient.gradient.sample(0.6), gradient.gradient.sample(0.05), gradient.gradient.sample(0)]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Hud/Time.text= times[current_level-1]
	$DirectionalLight2D.color = gradient.gradient.sample(current_level/6.0)
	if(current_level <=2):
		current_age = "child"
	if(current_level>2 and current_level<=4):
		current_age = "adult"
	if(current_level >4):
		current_age = "elder"


