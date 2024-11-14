extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var collectType = "spark"
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func _on_collectible_body_entered(body):
	print(body)
	remove_and_skip()
	pass # Replace with function body.


func _on_collectible_body_shape_entered(body_id, body, body_shape, local_shape):
	print("collected")
	remove_and_skip()
	pass # Replace with function body.


func _on_collectible_area_shape_entered(area_id, area, area_shape, local_shape):
	print("topuc")
	pass # Replace with function body.


func _on_Area_body_entered(body):
	if(body.has_method("pick_up")):
		body.pick_up(collectType)
	remove_and_skip()
	pass # Replace with function body.
