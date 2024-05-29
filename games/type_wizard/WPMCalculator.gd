class_name WPMCalculator
extends Node

@export var char_in_words := 5.0

var time := -1.0
var wpms := []

func get_average_wpm():
	var result = 0.0
	
	if wpms.is_empty():
		return result
	
	for wpm in wpms:
		result += wpm
	
	return result / wpms.size()

func start_type():
	time = 0.0

func cancel_type():
	time = -1.0

func finish_type(word: String):
	print("Finished with %s in %s" % [word, time])
	if word.length() == 1 or time < 0:
		return
	
	var words_count = word.length() / char_in_words
	var minute = time / 60.
	var wpm = words_count / minute
	wpms.append(wpm)
	cancel_type()

	print("Current WPM: %s" % wpm)

func _process(delta):
	if time < 0: return
	time += delta
