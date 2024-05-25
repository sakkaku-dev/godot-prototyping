class_name LevelManager
extends Node

signal level_up(lvl)
signal experience_change(exp)

var lvl := 1
var exp := 0.0:
	set(v):
		exp = v
		if exp >= 100:
			lvl += 1
			exp = 0
			level_up.emit(lvl)
		
		experience_change.emit(exp)

func receive_exp(enemy: TypedEnemy):
	var len = enemy.get_word().length()
	if len < 3:
		return
	
	self.exp += 10 if len < 9 else 20
