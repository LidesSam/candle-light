@tool
extends EditorPlugin

const mainPanelTemp= preload("fsmEditor.tscn")
var main_panel_instance

func _enter_tree():
	#this create the new custom nodes of the fsm.
	add_custom_type("Fsm","Node",preload("res://addons/fsmgear/source/Fsm.gd"),preload("res://addons/fsmgear/assets/fsm-icons/fsm.png"))
	add_custom_type("FsmState","Node",preload("source/FsmState.gd"),preload("assets/fsm-icons/fsmState.png"))

	#still in construction
	add_custom_type("FsmTrasition","Node",preload("source/FsmTransition.gd"),preload("assets/fsm-icons/fsmtransition.png"))
	
	main_panel_instance= mainPanelTemp.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)
	
	get_editor_interface().get_selection().selection_changed.connect( _on_selection_changed )
	
func _on_selection_changed():
	print("fsmGear: change")
	var selection = get_editor_interface().get_selection().get_selected_nodes()

	if selection.is_empty():
		main_panel_instance.clear_graph()
		return

	var node = selection[0]

	if node.get_script() == preload("res://addons/fsmgear/source/Fsm.gd"):
		print("FSM selected")
		main_panel_instance.show_fsm(node)
		return
	
	var childNode= find_child_target(node)
	if childNode:
		print("Child FSM selected")
		main_panel_instance.show_fsm(node)
		return
		
	var parentNode = find_parent_target(node)
	if parentNode:
		print("Parent FSM selected")
		main_panel_instance.show_fsm(node)
		return
	print("Selected node is not an FSM")
	main_panel_instance.clear_graph()
	
func find_child_target(node):
	for n in node.get_children():
		if n.get_script() == preload("res://addons/fsmgear/source/Fsm.gd"):
			return n
	return false


func find_parent_target(node):
	if node.get_parent().get_script() == preload("res://addons/fsmgear/source/Fsm.gd"):
		return node.get_parent()
	else:
		return false
	
	
func _make_visible(visible: bool):
	if visible:
		if main_panel_instance == null:
			main_panel_instance = mainPanelTemp.instantiate()
			get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
		main_panel_instance.visible = true
	else:
		if main_panel_instance:
			main_panel_instance.visible = false

func _exit_tree():
	if(main_panel_instance):
		main_panel_instance.queue_free()
	remove_custom_type("Fsm")
	remove_custom_type("FsmState")
	remove_custom_type("FsmTrasition")

#to draw this editor tab falte to hide tab "FSM-GEAR"
func _has_main_screen():
	return true;
#TiTLe of the tab and plugin
func _get_plugin_name():
	return "FSM-GEAR"
	
func _get_plugin_icon():
	return preload("assets/fsm-icons/fsm.png")
