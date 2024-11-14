@tool
extends Node


# parent class to all fsm States
#func _ready():
#	pass # Replace with function body.

var StateName = null
var parentFsm = null
var recursive=0
var transitions=[]

var enteraction=null
var exitaction=null

func _ready():
	pass

func setFsmParent(fsm):
	parentFsm=fsm

func enter(actowner):
	UpdateOwnerStateDisplay(actowner)
	print(actowner.name," enterState:",StateName)
	
	if(enteraction):
		enteraction.call()
	#print("enterState:",StateName)
	pass

func update(actowner,delta):
	pass

func handleInput(actowner,event):
	pass

func exit(actowner):
	print(exitaction)
	if(exitaction):
		exitaction.call()
	
func set_exitaction(callback:Callable):
	print("Setting exit action")
	exitaction=callback
	print(exitaction);
func set_enteraction(callback:Callable):
	print("Setting enter action")
	enteraction=callback
	print(exitaction);
	
func UpdateOwnerStateDisplay(actowner):
	if actowner.has_method("updateStateName"):
		actowner.updateStateName(StateName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
