extends TimedZoneSpell

func apply(body: TypedEnemy):
	var r = res as FireballResource
	body.burn_amount += r.burn_speed
