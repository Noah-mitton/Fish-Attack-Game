extends StaticBody2D
var flag = false

func _physics_process(delta):
	while !flag:
		$AnimationPlayer.play("Spin")
	if flag:
		queue_free()

func _on_Node2D_area_entered(area):
	flag = true
