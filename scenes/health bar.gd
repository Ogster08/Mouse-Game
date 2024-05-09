extends TextureProgressBar

@export var UI: Node

@onready var player = UI.player_ref

func _ready():
	max_value = player.MAX_HEALTH
	value = max_value

func _process(delta):
	value = move_toward(value, player.current_health, 60*delta)
	print(value)
	print(player.current_health)
