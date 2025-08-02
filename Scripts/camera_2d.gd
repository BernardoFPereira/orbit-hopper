extends Camera2D

@export var target: Node2D
var last_known_pos: Vector2

var shake_intensity = 0.0
var shake_decay = 2.0
var noise = FastNoiseLite.new()

func _ready():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH

func _process(delta):
	if target:
		last_known_pos = target.global_position
		global_position = global_position.lerp(last_known_pos, delta * 2)
	else:
		global_position = global_position.lerp(last_known_pos, delta)
	
	if shake_intensity > 0:
		var offset = Vector2(
			noise.get_noise_2d(float(randi_range(0,1000)), float(randi_range(0,1000))) * shake_intensity,
			noise.get_noise_2d(float(randi_range(0,1000)), float(randi_range(0,1000))) * shake_intensity
		)
		
		offset.x = clamp(offset.x,-1,1)
		offset.y = clamp(offset.y,-1,1)
		
		self.offset = offset
		shake_intensity -= shake_decay * delta * 2
		shake_intensity = max(shake_intensity, 0)
	else:
		self.offset = Vector2.ZERO

func shake(intensity):
	shake_intensity = intensity

########
#func _process(delta: float) -> void:
	#
	#if target:
		#last_known_pos = target.global_position
		#global_position = global_position.lerp(last_known_pos, delta * 2)
	#else:
		#global_position = global_position.lerp(last_known_pos, delta)
