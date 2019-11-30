extends Node

var run_time = 0 setget ,get_run_time
var debug_mode = false setget _private_set,get_debug

func _private_set(__throwaway__):
	if debug_mode:
		print('Private variable.')

func _process(delta):
	run_time += delta
	
func get_run_time():
	return run_time

func get_debug():
	return debug_mode

func set_debug(value : bool):
	debug_mode = value

# Get the node's original name before Godot made it unique.
func get_node_original_name(node):
	var node_name_array = node.name.split('@')
	return node_name_array[1] if node_name_array.size() > 1 else node_name_array[0]