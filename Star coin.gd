extends StaticBody2D

var flag = false

func _physics_process(delta):
	$AnimationPlayer.play("Spin")

func _on_Collectable_area_entered(area):
	queue_free()


