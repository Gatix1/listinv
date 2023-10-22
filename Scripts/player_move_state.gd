class_name PlayerMoveState
extends State

@onready var fsm = $".." as FiniteStateMachine
@onready var playerIdlelState = $"../PlayerIdleState" as PlayerIdleState
@export var actor: Player
@export var animator: AnimatedSprite2D

@export var speed = 30
@export var run_speed = 60
@export var friction = 0.2
@export var acceleration = 0.2


func _enter_state() -> void:
	if not actor.is_active:
		fsm.change_state(playerIdlelState)
		return
	
	# A little delay for smoother animation start
	set_physics_process(true)
	await get_tree().create_timer(0.05).timeout
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.y > 0:
		animator.play('walk_down')
	elif direction.length() > 0:
		animator.play('walk')

func _exit_state() -> void:
	set_physics_process(false)

func _physics_process(_delta):
	if not actor.is_active: return
	
	var direction = Input.get_vector("left", "right", "up", "down")
		
	if direction.length() > 0:
		if Input.is_action_pressed('run'):
			actor.velocity = actor.velocity.lerp(direction.normalized() * run_speed, acceleration)
			animator.speed_scale = 1.5  
		else:
			actor.velocity = actor.velocity.lerp(direction.normalized() * speed, acceleration)
			animator.speed_scale = 1
	else:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, friction)
		fsm.change_state(playerIdlelState)
		
	actor.move_and_slide()
