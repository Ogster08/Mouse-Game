extends TextureProgressBar

@export var UI: Node

@onready var player = UI.player_ref
#@onready var tween = create_tween()
#@onready var health : float

func _ready():
	value = max_value
	#player.HEALTH_CHANGED.connect(update)
	#update()

func _process(delta):
	#print(value)
	#print(player.current_health)
	#print(1*delta)
	#print(move_toward(value, player.current_health, 5*delta))
	value = move_toward(value, player.current_health, 5*delta)
	print(player.current_health)
	print(value)
	#value = health

#func update_value(health: float):
	#value = health
	#print("called")

#func update():
	#health = player.current_health / player.MAX_HEALTH * 100
	#if tween:
		#tween.kill()
	#tween = create_tween()
	#tween.tween_method(update_value, value, health, 0.8)
