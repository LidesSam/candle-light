@tool
extends EditorPlugin

const mainPanelTemp= preload("fsmEditor.tscn")
var main_panel_instance

func _enter_tree():
	add_custom_type("Fsm","Node",preload("source/Fsm.gd"),preload("assets/fsm-icons/fsm.png"))
	add_custom_type("FsmState","Node",preload("source/FsmState.gd"),preload("assets/fsm-icons/fsmState.png"))
	add_custom_type("FsmTrasition","Node",preload("source/FsmTransition.gd"),preload("assets/fsm-icons/fsmtransition.png"))
	
	main_panel_instance= mainPanelTemp.instance()
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)

func _make_visible(visible):
	if(main_panel_instance):
		main_panel_instance.visible=visible

func _exit_tree():
	if(main_panel_instance):
		main_panel_instance.queue_free()
	remove_custom_type("Fsm")
	remove_custom_type("FsmState")
	remove_custom_type("FsmTrasition")
	
	pass

#to draw this editor tab
func _has_main_screen():
	return true;
#TiTLe of the tab and plugin
func _get_plugin_name():
	return "FSM-GEAR"
	
func _get_plugin_icon():
	return preload("assets/fsm-icons/fsm.png")
