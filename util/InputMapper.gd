class_name InputMapper

static func override_key_inputs(inputs: Dictionary):
	for action in InputMap.get_actions():
		if action.begins_with("ui_"): continue # getting errors if build-in actions doesn't exist
		InputMap.erase_action(action)

	for action in inputs:
		InputMap.add_action(action)
		
		var value = inputs[action]
		if not value is Array:
			value = [inputs[action]]

		for k in value:
			var ev = InputEventKey.new()
			ev.keycode = k
			InputMap.action_add_event(action, ev)

static func key(k: int) -> InputEventKey:
	var ev = InputEventKey.new()
	ev.keycode = k
	return ev

static func joy_btn(k: int) -> InputEventJoypadButton:
	var ev = InputEventJoypadButton.new()
	ev.button_index = k
	return ev

static func joy_stick(axis: int, value: int) -> InputEventJoypadMotion:
	var ev = InputEventJoypadMotion.new()
	ev.axis = axis
	ev.axis_value = value
	return ev
