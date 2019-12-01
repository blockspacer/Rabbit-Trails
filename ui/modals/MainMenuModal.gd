extends VBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$NewGameButton.connect('pressed', self, '_on_NewGameButton_pressed')
	$ExitButton.connect('pressed', self, '_on_ExitButton_pressed')
	
	if not UserData.has('has_current_game') or UserData.get('has_current_game') == false:
		$ContinueButton.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_NewGameButton_pressed():
#	breakpoint
	UserData.set('has_current_game', true)
	UserData.set('current_stage_name', 'TutorialStage')
	get_tree().change_scene('res://screens/GameScreen.tscn')

func _on_ExitButton_pressed():
	get_tree().quit()