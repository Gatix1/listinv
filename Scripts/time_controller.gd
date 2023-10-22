class_name TimeController
extends Node

@export var actor: CharacterBody2D

#----Rewind Time Variables----#
var frames_rewinded: float = 0.0
var replay_duration: float = 300.0
var rewinding: bool = false
var rewind_values = {
	"position": [],
	"rotation": [],
	"velocity": [],
	"animation": [],
	"animation_speed_scale": [],
	"direction": []
}

func _physics_process(delta: float) -> void:
	if not rewinding:
		if replay_duration * Engine.get_frames_per_second() == rewind_values["position"].size():
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
		rewind_values["position"].append(actor.global_position)
		rewind_values["rotation"].append(actor.rotation)
		rewind_values["velocity"].append(actor.velocity)
		rewind_values["direction"].append(actor.direction)
		rewind_values["animation"].append(actor.animator.animation)
		rewind_values["animation_speed_scale"].append(actor.animator.speed_scale)
	else:
		compute_rewind(delta)

func set_time_scale(speed_scale : float) -> void:
	Engine.time_scale = speed_scale

func rewind() -> void:
	rewinding = true
	#$PlayerCollision.disabled = true

func compute_rewind(_delta : float):
	frames_rewinded += 1
	
	var pos = rewind_values["position"].pop_back()
	var rot = rewind_values["rotation"].pop_back()
	var dir = rewind_values["direction"].pop_back()
	var anim = rewind_values["animation"].pop_back()
	var anim_speed_scale = rewind_values["animation_speed_scale"].pop_back()
	
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO and frames_rewinded > 60:
			stop_rewind()
	# Stop rewinding if there are no positions left
	if rewind_values["position"].size() == 1:
		#   $PlayerCollision.disabled = false
		rewinding = false
		actor.global_position = pos
		actor.rotation = rot
		actor.direction = dir
		actor.animator.animation = "idle"
		actor.animator.speed_scale = 1
		actor.velocity = rewind_values["velocity"][0]
		return
	
	actor.global_rotation = rot 
	actor.global_position = pos
	actor.direction = dir
	actor.animator.animation = anim
	actor.animator.speed_scale = anim_speed_scale
	
func stop_rewind() -> void:
	frames_rewinded = 0
	var pos = rewind_values["position"].pop_back()
	var rot = rewind_values["rotation"].pop_back()
	var dir = rewind_values["direction"].pop_back()
	var anim = rewind_values["animation"].pop_back()
	
	rewinding = false
	actor.global_position = pos
	actor.rotation = rot
	actor.direction = dir
	actor.animator.animation = "idle"
	actor.animator.speed_scale = 1
	actor.velocity = rewind_values["velocity"][0]
	
	rewind_values["position"].clear()
	rewind_values["rotation"].clear()
	rewind_values["direction"].clear()
	rewind_values["animation"].clear()
	rewind_values["animation_speed_scale"].clear()
	return
