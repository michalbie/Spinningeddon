tool
extends EditorPlugin

var undo_redo

var dock
var current_selected
var mouse_pos

func _enter_tree():
	undo_redo = get_undo_redo()
	set_process_input(true)
	dock = preload("res://addons/MapEditorDock/MapEditorDock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	
	dock.connect("button_pressed", self, "set_current_selected")
	
func set_current_selected(name):
	current_selected = name
	print(name)
	
func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = get_editor_interface().get_edited_scene_root().get_viewport().get_mouse_position()

	elif event is InputEventKey:
		if event.pressed and event.scancode == KEY_F7:
			create(current_selected, mouse_pos)

func create(selected_name, mp):
	var node
	var preload_string = "res://Maps/Objects/" + str(selected_name) + ".tscn"
	node = load(preload_string).instance()
	node.global_position = mp
	undo_redo.create_action("Create object")
	undo_redo.add_do_method(self, "add_object", node)
	undo_redo.add_undo_method(self, "delete_object", node)
	undo_redo.commit_action()


func add_object(node):
	get_editor_interface().get_edited_scene_root().add_child(node)
	node.set_owner(get_editor_interface().get_edited_scene_root())
	
func delete_object(node):
	get_editor_interface().get_edited_scene_root().remove_child(node)
	node.set_owner(null)
	node.queue_free()

func _exit_tree():
	remove_control_from_docks(dock)
	dock.free()
	
