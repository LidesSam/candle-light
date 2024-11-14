@tool
extends Node

var actowner=null

var states = []
var statesNames = []

var globalToStates= []
var globalContiditions= []
var currentState=null
var currentStateAsignedName=""

var textTarget = null
var uptateTextTarget=false
var fsmDebug=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_debug_on(targetForStateText):
	fsmDebug = true
	uptateTextTarget = true
	textTarget = targetForStateText
	

func set_owner(Owner,targetText=null):
	print("setting owner")
	actowner=Owner
	if(targetText):
		textTarget =targetText
		uptateTextTarget =true
	pass

#remove all states
func clear_states():
	states = []
	statesNames = []
	currentState=null
	
func autoload(Owner):
	#print(actowner.name)
	self.set_owner(Owner,null)
	#print(actowner.name)
	for st in get_children():
		print("adding state:",st.name)
		addState(st.name,st)
	
func addStateTransition(enterStateName,exitStateName,funcName:Callable):
	
	if(statesNames.find(enterStateName)!=-1):
		if(statesNames.find(exitStateName)!=-1):
			var idx=statesNames.find(enterStateName)
			var state = states[idx]
			var fsmTrans = preload("FsmTransition.gd").new()
			var condRef = funcName
			fsmTrans.define(exitStateName,condRef)
			state.transitions.push_back(fsmTrans)
		else:
			print("not find exit state:",exitStateName)
	else:
		print("not find enter state:",enterStateName)
	
func addGlobalTransition(stateName,funcName:Callable):
	globalToStates.push_back(stateName)
	var condRef = funcName
	globalContiditions.push_back(condRef)
	
func addState(state_name, st):
#	create state and past this as parent
	st.setFsmParent(self)
	st.StateName= state_name
	states.push_back(st)
	statesNames.push_back(st.StateName)

	
func startState():
	currentStateAsignedName=statesNames[0]
	currentState = states[0]
	currentState.enter(actowner)

func getCurrentStateName():
	return currentStateAsignedName
	
func fsmUpdate(delta):
	
	currentState.update(actowner,delta)
	#check for global tarnstion
	if(globalContiditions):
		for i in range(globalContiditions.size()):
			if(globalContiditions[i].call()):
				change_to_state(globalToStates[i])
				break
	#get the transitions state to the current state
	
	for t in currentState.transitions:
		#check an trigger one by one.
		if(t.checkCondition(self)):
			break
		
		
		
	if(textTarget and uptateTextTarget):
			textTarget.text= getCurrentStateName()

func handleInput(event):
	currentState.handleInput(actowner,event)

#change state
func change_state(nextState):
	if(currentState!=nextState):
		currentState.exit(actowner)
		currentState = nextState
		currentState.enter(actowner)

#change to the state by index
func change_state_by_index(idx):
	change_state(states[idx])

#change to the state by name
func change_to_state(state_name):
	if(currentStateAsignedName!=state_name):
		var idx =0
		for st in statesNames:
			if st == state_name:
				currentStateAsignedName=state_name
				change_state_by_index(idx)
			idx+=1
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
