extends Node

###
# Data that will be saved in local state
###
var current_stage = null
var current_stage_name = ''
#var current_stage_index = 0
var next_stage_name = ''

export(Array, String, FILE, '*Stage.tscn') var stages = []

var loaded_stages = []

var track_stage_time = false
var stage_time = 0.00
var stage_time_step = 0.0

func _init():
#	current_stage_index = UserData.get('current_stage_index')
	current_stage_name = UserData.get('current_stage_name')

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignal.listen('victory', self, '_on_Victory')
	GlobalSignal.listen('advance_stage', self, '_on_Advance_stage')
	GlobalSignal.listen('restart_stage', self, '_on_Restart_stage')
	if stages.size() > 0:
		for stage in stages:
			var loaded_stage = load(stage)
			loaded_stages.push_back(loaded_stage)
	load_stage(get_stage_with_name(current_stage_name))

func _process(delta):
	if track_stage_time:
		update_stage_time(delta)

func _on_Victory(data):
	stop_stage_time()
	if data.has('next_stage'):
		next_stage_name = data.next_stage

func _on_Advance_stage():
	if get_tree().paused:
		get_tree().paused = false
	GlobalSignal.dispatch('kill_dialogue') # If we are somehow in the middle of a scene, stop it.
	unload_current_stage()
	load_stage(get_stage_with_name(next_stage_name))

func _on_Restart_stage():
	var next_stage_name = current_stage_name
	GlobalSignal.dispatch('kill_dialogue') # If we are somehow in the middle of a scene, stop it.
	unload_current_stage()
	load_stage(get_stage_with_name(next_stage_name))

func get_stage_at_index(stage_index):
	return loaded_stages[stage_index]

func get_stage_with_name(stage_name):
	for stage in loaded_stages:
		var inst_stage = stage.instance() # This feels ugly
		if inst_stage.name == stage_name:
			return inst_stage
		inst_stage.queue_free() # Don't need itnow, remove it
	return null

func load_stage(stage):
	current_stage = stage
	current_stage_name = stage.name
	add_child(current_stage)
	Score.reset_current_score()
	Rabbits.reset()
	Rabbits.all_rabbits_added = false
	Selection.clear_selection()
	start_stage_time()

func unload_current_stage():
	if current_stage != null:
		remove_child(current_stage)
		current_stage.queue_free()
		current_stage = null
		current_stage_name = ''

func start_stage_time():
	track_stage_time = true
	stage_time = 0.0
	stage_time_step = 0.0
	GlobalSignal.dispatch('stage_time_updated', { 'time': int(stage_time) })

func stop_stage_time():
	track_stage_time = false
	GlobalSignal.dispatch('stage_time_updated', { 'time': int(stage_time)  })

func update_stage_time(time):
	stage_time += time
	stage_time_step += time
	if stage_time_step >= 1:
		GlobalSignal.dispatch('stage_time_updated', { 'time': int(stage_time)  })
		stage_time_step = stage_time_step - 1