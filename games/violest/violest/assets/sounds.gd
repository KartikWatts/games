extends Node2D

@onready var main_bgm = $MainBgm
@onready var click_sound = $ClickSound

func play_bgm():
	main_bgm.play()

func play_click_sound():
	click_sound.play()
	await click_sound.finished
