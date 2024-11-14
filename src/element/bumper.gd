extends RigidBody3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_bumper_body_entered(body):
	print("body bump1")
	if(body.has_method("rebound")):
		body.rebound()
	pass # Replace with function body.


func _on_bumper_body_shape_entered(body_id, body, body_shape, local_shape):
	print("body bump2")
	if(body.has_method("rebound")):
		body.rebound()
	pass # Replace with function body.


func _on_Area_body_entered(body):
	print("body bump3")
	if(body.has_method("rebound")):
		body.rebound()
	pass # Replace with function body.
