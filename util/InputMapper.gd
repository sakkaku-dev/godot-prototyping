class_name InputMapper

static func override_key_inputs(inputs: Dictionary):
	for action in InputMap.get_actions():
		if action.begins_with("ui_"): continue # getting errors if build-in actions doesn't exist
		InputMap.erase_action(action)

	for action in inputs:
		InputMap.add_action(action)
		
		var ev = InputEventKey.new()
		ev.keycode = inputs[action]
		InputMap.action_add_event(action, ev)
