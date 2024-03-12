extends Area2D

signal died()
signal blocked()

@export var health := 1
@export var type := Parasite.Type.ROCK

func damage(dmg: int, type: Parasite.Type):
	print("%s is attacking %s" % [Parasite.Type.keys()[type], Parasite.Type.keys()[self.type]])
	if Parasite.winning_type(type) != self.type:
		blocked.emit()
		return
		
	health -= dmg
	
	if health <= 0:
		died.emit()
