@tool
extends Node

@export var nexState=null
@export var condition: Callable 


#used in 
var canToSelf=false
var triggerName="unknown error "

func _ready():
	pass # Replace with function body.

func define(nstate,cond:Callable):
	nexState=nstate
	condition=cond
	triggerName=cond.get_method()
	pass

func check_condition(fsm):
	if(condition.call()):
		print("aowner:",fsm.actowner.name,"  triger:",triggerName," nstate:",nexState)
		fsm.change_to_state(nexState)
		return true
	return false
