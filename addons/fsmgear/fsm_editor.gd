@tool
extends Control

var editor_interface
var statesNodes: Array[GraphNode] = []
@onready var statesDisplay:GraphEdit=$GraphEdit
var currentTarget=null
@onready var targetNameLbl:Label=$sidebar/TargetLbl
@onready var fsmStatesList:Control= $sidebar/fsmStates

func _ready() -> void:
	targetNameLbl=$sidebar/TargetLbl
	
func show_fsm(node):
	currentTarget=null
	currentTarget=node
	targetNameLbl.text = node.name
	current_target_data()
	
func current_target_data():
	if !currentTarget:
		return
	var i = 0
	
	for state in currentTarget.get_children():
		i += 1
		var stateDispNode: GraphNode = GraphNode.new()
		stateDispNode.title = state.name
		#stateDispNode.position = Vector2(16, 16 + 48* i)
		if state.has_meta("graph_position"):
			stateDispNode.position_offset = state.get_meta("graph_position")
		else:
			stateDispNode.position_offset = Vector2(16, 16 + 48 * i)
		# Save position whenever the GraphNode moves
		stateDispNode.position_offset_changed.connect(
			func():
				state.set_meta("graph_position", stateDispNode.position_offset)
		)
		statesDisplay.add_child(stateDispNode)
		statesNodes.push_back(stateDispNode)
		var statelistlbl = Label.new()
		statelistlbl.text= state.name
		fsmStatesList.add_child(statelistlbl)
		
	

func clear_graph(clearTarget=true):
	targetNameLbl.text = "clearing"
	if clearTarget:
		currentTarget=null
		targetNameLbl.text = "No FSM"
	else:
		targetNameLbl.text = "Nix"
	for child in statesDisplay.get_children():
		if child is GraphNode:#to prevent missin conection_layer
			child.queue_free()
	for child in fsmStatesList.get_children():
		child.queue_free()

func get_unique_state_name(stateName: String) -> String:
	if not currentTarget:
		return stateName
	var newName= stateName
	var count= 1

	while currentTarget.has_node(newName):
		newName = stateName + str(count)
		count += 1

	return newName

func _on_add_pressed() -> void:
	if currentTarget:
		var stateName = $sidebar/newStateNameEditLine.text.strip_edges()
		print(stateName)
		if stateName.is_empty() :
			stateName = "STATE%d" % (currentTarget.get_child_count() + 1)
		else:
			#duplicate state add number at the end
			stateName= get_unique_state_name(stateName)
		var fsmstate = preload("res://addons/fsmgear/source/FsmState.gd").new()
		fsmstate.name = stateName
		currentTarget.add_child(fsmstate)
		fsmstate.owner = currentTarget.owner
		clear_graph(false)
		current_target_data()
			
		
