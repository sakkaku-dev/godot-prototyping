extends RandomTimer

func random_start():
	var multiplier = (1. / KfpManager.stars) if KfpManager.stars > 0 else 1.
	var time = randf_range(min_time * multiplier, max_time * multiplier)
	start(time)
