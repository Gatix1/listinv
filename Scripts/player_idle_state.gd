class_name PlayerIdleState
extends State

@onready var fsm = $".." as FiniteStateMachine
@onready var playerMoveState = $"../PlayerMoveState" as PlayerMoveState
@export var actor: Player
@export var animator : AnimatedSprite2D

func _enter_state() -> void:
	
	# A little delay for smoother animation start
	await get_tree().create_timer(0.05).timeout
	print(animator.animation)
	if animator.animation == 'walk_down':
		animator.play('idle_down')
	else:
		animator.play('idle')

func _physics_process(_delta):
	# Read and check if there is some movement for the movement
	# Call Move State if there is
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0 and (not actor.dialogueController.dialoguePanel.visible):
		fsm.change_state(playerMoveState)
