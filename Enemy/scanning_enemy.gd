extends CharacterBody3D
class_name ScanningEnemy


@onready var ray_cast_3d: RayCast3D = $RayCast3D

@export var max_hitpoints := 100
@export var attack_range := 1.5
@export var attack_damage := 20
@export var aggro_range := 12

const SPEED = 5.0
var player : CharacterBody3D
var provoked := false
#var aggro_range := 12.0
var hitpoints: int = max_hitpoints:
	set(value):
		hitpoints = value
		if hitpoints <= 0:
			queue_free()
		provoked = true

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	
func _process(_delta: float) -> void:
	#if provoked:
		#navigation_agent_3d.target_position = player.global_position
		pass
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#var direction = global_position.direction_to(next_position)
	var direction = global_position.direction_to(player.global_position)
	var distance = global_position.distance_to(player.global_position)
	printt("Direction: ", direction, "Distance: ", distance)
	if distance <= aggro_range:
		provoked = true
	#else:
		#provoked = false

	if provoked:
		if distance <= attack_range:
			pass
			#animation_player.play("attack")
		
	if direction:
		var target_pos = player.global_transform.origin
		look_at(target_pos, Vector3.UP, true)
		#ray_cast_3d.target_position= player.global_position * 1000
		ray_cast_3d.target_position = (player.global_position - global_position).normalized() * 1000
		#ray_cast_3d.set_target_position(player.global_position)
		print("Raycast enabled:", ray_cast_3d.enabled)
		print("Raycast target:", ray_cast_3d.target_position)
		print("Raycast colliding:", ray_cast_3d.is_colliding())		
		print("Raycase collision with:", ray_cast_3d.get_collider())
		if ray_cast_3d.is_colliding():
			var collider = ray_cast_3d.get_collider()
			if collider is Player:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

#func look_at_target(direction: Vector3) -> void:
	#var adjusted_direction = direction
	#adjusted_direction.y = 0
	#look_at(global_position + adjusted_direction, Vector3.UP, true)
	
func attack() -> void:
	player.hitpoints -= attack_damage
	printt("Enemy Attack! " , player.hitpoints)
