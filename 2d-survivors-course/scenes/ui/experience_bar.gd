extends CanvasLayer

@export var experience_manager: ExperienceManager
@onready var progress_bar = %ProgressBar

func _ready():
	progress_bar.value = 0
	experience_manager.experience_updated.connect(on_experience_updated)


func on_experience_updated(current_exprience: float, target_experience: float):
	var percent = current_exprience/target_experience
	progress_bar.value = percent 
	
