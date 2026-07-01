extends CharacterBody3D

@export var player: Node3D
@export var move_speed: float = 3.0 # Speed at which the enemy chases
@export var max_hitpoints := 100
@export var attack_range := 1.5
@export var attack_damage := 20
@export var aggro_range := 12
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var raycast: RayCast3D = $RayCast3D

# Get the standard gravity from project settings
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var provoked := false

func _physics_process(delta: float) -> void:
	# 1. Apply gravity so the enemy stays on the floor
	if not is_on_floor():
		velocity.y -= gravity * delta

	if player:
		# 2. Point the raycast at the player
		var distance = global_position.distance_to(player.global_position)
		raycast.target_position = raycast.to_local(player.global_position)
		if distance <= aggro_range:
			provoked = true
	#else:
		#provoked = false

		if provoked:
			if distance <= attack_range:
				animation_player.play("attack")
	
		# 3. Check for line of sight
		if raycast.is_colliding() and raycast.get_collider() == player:
			
			# --- CHASE LOGIC ---
			# Calculate the direction to the player
			var direction = (player.global_position - global_position).normalized()
			
			# Move the enemy toward the player
			velocity.x = direction.x * move_speed
			velocity.z = direction.z * move_speed
			
			# Make the enemy physically turn to face the player
			# We use global_position.y for the target Y so the enemy doesn't tilt up/down
			var look_target = Vector3(player.global_position.x, global_position.y, player.global_position.z)
			look_at(look_target, Vector3.UP)
			
		else:
			# --- IDLE LOGIC ---
			# If line of sight is broken, smoothly bring the enemy to a stop
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)
			
	# 4. Execute the movement and handle wall/floor collisions
	move_and_slide()

func attack() -> void:
	player.hitpoints -= attack_damage
	printt("Enemy Attack! " , player.hitpoints)
