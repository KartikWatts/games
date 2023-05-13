extends ParallaxLayer

const cloud_speed := -15

func _process(delta):
	self.motion_offset.x += (cloud_speed * delta)
