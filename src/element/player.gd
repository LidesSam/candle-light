extends KinematicBody


export var speed = 100
export var jump_strenght = 50
export var gravity = 50

var vel = Vector3.ZERO
var c_acel =0

var snap_vector = Vector3.DOWN

	

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anims= $AnimationPlayer
var grounded = false

var speedCap = 10

var justLanded=false
var injump=false
# Called when the node enters the scene tree for the first time.


var sparks =0
func _ready():
	c_acel=0
	$AnimationPlayer.play("idle")
#	print($RayCast.cast_to)
#	cross_product($RayCast.cast_to,rotation)
	pass # Replace with function body.

func _input(event):
	pass
	
func _physics_process(delta):
	if($boostTime.is_stopped()):
		var foward_force=0
		foward_force	= Input.get_action_strength("ui_up")*10
		
		
		var rot_force =Input.get_action_strength("ui_left")-Input.get_action_strength("ui_right")
		
		
		if(foward_force>0):
			c_acel+=foward_force*delta
			if(c_acel>100):
				c_acel=100
		elif c_acel>=0:
			c_acel-=10*delta
		else:
			c_acel+=10*delta
			if(c_acel>0):
				c_acel=0
		

		rotate_y(rot_force*delta)
		
	var aux= get_transform().basis.z
	vel.x = aux.x*c_acel
	vel.z = aux.z*c_acel
	if(vel.y>=-gravity):
		vel.y -= gravity*delta+aux.y*c_acel
	else:
		vel.y =- gravity+aux.y*c_acel
	
	justLanded = is_on_floor() and snap_vector == Vector3.ZERO
	injump = is_on_floor() and Input.is_action_just_pressed("ui_back")
	
	
	$Camera/Control/floorAngle.text = str("angle:",get_floor_angle())
	$Camera/Control/floorNormal.text = str("normal:",get_floor_normal())
		
	if(injump):
		vel.y = jump_strenght
		snap_vector =Vector3.ZERO
	elif justLanded:
		snap_vector =Vector3.DOWN
		
		pass
	var rcast =$RayCast.cast_to

	move_and_slide_with_snap(vel, snap_vector,Vector3.UP,true,4,deg2rad(45))
#	used abs(c_acel) to consider negative values
	
#	rotation =  cross_product(get_floor_normal(),cross_product(rotation,rcast))
	
	if(not is_on_floor()):
		$AnimationPlayer.play("on air")
	elif(abs(c_acel)>5):
		if (abs(c_acel)>25):
			$AnimationPlayer.play("sliding",-1,2.0)
		else:
			$AnimationPlayer.play("sliding")
	else:
		$AnimationPlayer.play("idle")
	$Camera/Control/accel.text=str("accel:",c_acel)



func aling_with_floor():
	
	pass
	
func cross_product(u=Vector3.UP,v=Vector3.UP):
	var w = Vector3.ZERO
	w.x = u.y*v.z-u.z*v.y
	w.y = u.x*v.z-u.z*v.x
	w.z = u.x*v.z-u.x*v.y
	print("u: ",u," v:",v)
	print(w)
	return  w
#	print($RayCast.cast_to)
	

func pick_up(collectType="",points =1):
	match collectType:
		"spark":
			sparks+=points
			update_sparks()
		_:
			print("colletion type NO RECOGNIZED")

#update sparks counters
func update_sparks():
	$Camera/Gui/sparks/count.text = str(sparks)
	
#aply accel in a direction
#warnig
#(direction not implemented)
#only set accel on max
func boost(dir = Vector3.ZERO):
	if(dir!=null):
		print("boost")
		$boostTime.start()
		c_acel=100
#invert accel to cause a rebound effect		
#bounce used to alter rebound speed
func rebound(bounce=1):
	if(c_acel>=0):
		c_acel=-c_acel*bounce
#func _physics_process(delta):
#	var foward = Input.get_action_strength("ui_up")
#	var hturn =Input.get_action_strength("ui_left")-Input.get_action_strength("ui_right")
##
#	$Camera/Control/Label.text=str("foward:",foward)
#	if(foward>0):
#		var dir = -get_transform().basis.z
#		apply_impulse(Vector3.ZERO,Vector3(dir.x,0,dir.z))
##		apply_impulse(Vector3.ZERO,dir)
#
#		$AnimationPlayer.play("sliding")
#	else:
#		$AnimationPlayer.play("idle")
#	pass
#	angular_velocity =Vector3(0,hturn,0)
##	var ray = $RayCast.get
#	if Input.is_action_just_pressed("ui_back"):
#
#		apply_impulse(Vector3.ZERO,Vector3.UP*10)
#		pass
#

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_boostTime_timeout():
	$boostTime.stop()
	pass # Replace with function body.
