class_name CSVParser
extends Node

# Function to parse a single line of CSV while considering quoted fields
static func parse_csv_line(line: String) -> PackedStringArray:
	var result: PackedStringArray = []
	var current_field: String = ""
	var in_quotes: bool = false
	
	for i in range(line.length()):
		var char = line[i]
		
		if char == '"':
			# Toggle in_quotes when encountering a quote
			in_quotes = !in_quotes
		elif char == ',' and not in_quotes:
			# If not inside quotes, a comma indicates a new field
			result.append(current_field)
			current_field = ""
		else:
			# Otherwise, append character to the current field
			current_field += char
			
	# Add the last field to the result
	if not (result.is_empty() and current_field == ""):
		result.append(current_field)
	
	return result

# Function to parse the entire CSV file
static func parse_csv(file_path: String) -> Array:
	var data: Array = []
	
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		# Read the header line and split it into columns
		var header: PackedStringArray = parse_csv_line(file.get_line().strip_edges())
		
		while not file.eof_reached():
			# Read each line and split using the custom parser
			var line: String = file.get_line().strip_edges()
			var values: PackedStringArray = parse_csv_line(line)
			if values.is_empty(): continue
			
			# Create a dictionary for each line using header as keys
			var entry: Dictionary = {}
			for i in range(header.size()):
				var key = header[i]
				if i >= values.size(): break
				entry[key] = values[i]
				
			if not entry.is_empty():
				data.append(entry)
		file.close()
	else:
		print("CSV file not found at: ", file_path)
	
	return data
