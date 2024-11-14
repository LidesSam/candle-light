extends RigidBody3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@onready var light = $Light3D

# Called when the node enters the scene tree for the first time.
func _ready():
#	light.light_color = "#ffff00"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass





func _on_Trigger_body_shape_entered(body_id, body, body_shape, local_shape):
	
	if(body.name=="proto"):
		light.light_color = "#ffff00"
	pass # Replace with function body.
