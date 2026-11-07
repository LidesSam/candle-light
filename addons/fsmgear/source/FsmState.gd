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

func set_fsm_parent(fsm):
	parentFsm=fsm

func enter(actowner):
	update_owner_state_display(actowner)
	print(actowner.name," enterState:",StateName)
	
	if(enteraction):
		enteraction.call()
	#print("enterState:",StateName)
	pass

func update(actowner,delta):
	pass

func handle_input(actowner,event):
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
	
func update_owner_state_display(actowner):
	if actowner.has_method("update_state_name"):
		actowner.update_state_name(StateName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
