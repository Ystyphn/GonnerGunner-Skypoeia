extends CanvasLayer


onready var hpBar: TextureProgress = $playerUI/NinePatchRect/VBoxContainer/NinePatchRect/HP
onready var score: Label = $playerUI/NinePatchRect/Label
onready var staminaBar: TextureProgress = $playerUI/NinePatchRect/VBoxContainer/NinePatchRect3/Stamina
onready var boostBar: TextureProgress = $playerUI/NinePatchRect/VBoxContainer/NinePatchRect2/Boost
onready var waveCounter: Label = $playerUI/NinePatchRect/WaveCounter/Label

func initialize(current_health: int, max_health: int,
		current_stamina: int, max_stamina: int,
		current_boost: int, max_boost: int):
	hpBar.max_value = max_health
	hpBar.value = current_health
	staminaBar.max_value = max_stamina
	staminaBar.value = current_stamina
	boostBar.max_value = max_boost
	boostBar.value = current_boost

func update_health(current_health: int):
	hpBar.value = current_health

func update_score(current_score: int):
	score.text = str(current_score)

func update_stamina(current_stamina: int):
	staminaBar.value = current_stamina

func update_wave(current_wave: int):
	waveCounter.text = str(current_wave)

func update_boost(current_fuel: int):
	boostBar.value = current_fuel

func _on_TextureButton_pressed():
	Globals.paused =true
	Menu.show(true)
