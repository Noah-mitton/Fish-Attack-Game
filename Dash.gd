extends Node2D
var running = false
var timeout = false

onready var duration_timer = $DurationTimer

func start_dash(duration):
	duration_timer.wait_time = duration
	duration_timer.start()
	running = true
	
func is_dashing():
	return running if running else false


func _on_DurationTimer_timeout():
	running = false
	timeout = true
	var t = Timer.new()
	t.set_wait_time(0.01)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	timeout = false
	t.queue_free()
	
