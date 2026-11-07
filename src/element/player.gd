extends CharacterBody3D

@export var speed:float = 100
@export var speedLimit:float = 10
@export var jumpStrenght:float = 50
@export var gravity:float = 50

var vel = Vector3.ZERO
var c_acel =0
var snap_vector = Vector3.DOWN

@onready var animPlayer:AnimationPlayer=$"proto1-candle7a/AnimationPlayer"	

#flag
var grounded = false
var justLanded = false
var injump = false

#sensors
@onready var groundSensor:RayCast3D = $groundSensor
@onready var slopeClifSensor:RayCast3D = $slopeClifSensor
@onready var frontSensor:RayCast3D = $frontSensor


#charge collectible mode to item bag item
var sparks =0


@onready var fsm =$Fsm
func _ready():
	gravity=50
	c_acel=0
	animPlayer.play("idle")
	fsm.autoload(self)
	fsm.add_state_transition("idle","jump",is_jumping)
	fsm.add_state_transition("idle","fall",is_falling)
	fsm.add_state_transition("jump","fall",is_falling)
	fsm.add_state_transition("fall","idle",on_ground)
	fsm.start_fsm()
	fsm.set_debug_on($Camera3D/Gui/debug)

func _input(event):
	fsm.handleInput(self)
	
func _physics_process(delta):
	fsm.fsm_update(delta)
	
func basic_physics(delta):
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
	print(vel.y)
	print(gravity)
	if(vel.y>=-gravity):
		vel.y -= gravity*delta+aux.y*c_acel
	else:
		vel.y =- gravity+aux.y*c_acel
	
	justLanded = is_on_floor() and snap_vector == Vector3.ZERO
	injump = is_on_floor() and Input.is_action_just_pressed("ui_back")
	
	
	$Camera3D/Control/floorAngle.text = str("angle:",get_floor_angle())
	$Camera3D/Control/floorNormal.text = str("normal:",get_floor_normal())
		
	if(injump):
		vel.y = jumpStrenght
		snap_vector =Vector3.ZERO
	elif justLanded:
		snap_vector =Vector3.DOWN
	var rcast =groundSensor.target_position
	if groundSensor.get_collider():
		grounded=true
	set_velocity(vel)
	# TODO
	#Converter3To4 looks that snap in Godot 4 is float, 
	#not vector like in Godot 3 - previous value `snap_vector`
	set_up_direction(Vector3.UP)
	set_floor_stop_on_slope_enabled(true)
	set_max_slides(4)
	set_floor_max_angle(deg_to_rad(45))
	move_and_slide()
	
	if(not is_on_floor()):
		animPlayer.play("on air")
	elif(abs(c_acel)>5):
		if (abs(c_acel)>25):
			animPlayer.play("sliding",-1,2.0)
		else:
			animPlayer.play("sliding")
	else:
		animPlayer.play("idle")
	$Camera3D/Control/accel.text=str("accel:",c_acel)



func aling_with_floor():
	
	pass


#move to global???
func cross_product(u=Vector3.UP,v=Vector3.UP):
	var w = Vector3.ZERO
	w.x = u.y*v.z-u.z*v.y
	w.y = u.x*v.z-u.z*v.x
	w.z = u.x*v.z-u.x*v.y
	print("u: ",u," v:",v)
	print(w)
	return  w
	
#move to bag??
func pick_up(collectType="",points =1):
	match collectType:
		"spark":
			sparks+=points
			update_sparks()
		_:
			print("colletion type NO RECOGNIZED")

#update sparks counters
func update_sparks():
	$Camera3D/Gui/sparks/count.text = str(sparks)
	
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
#conditions

func on_ground():
	return grounded
	
func next_to_cliff():
	return grounded and !slopeClifSensor.get_collider()
func is_jumping():
	return injump
func is_falling():
	return velocity.z>0
#callbacks
func _on_boostTime_timeout():
	$boostTime.stop()
