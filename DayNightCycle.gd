extends CanvasModulate

@export var gradient:GradientTexture1D

var time:float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	var value = (sin(time / 2 - PI / 2) + 1.0) / 2.0
	self.color = gradient.gradient.sample(value)
