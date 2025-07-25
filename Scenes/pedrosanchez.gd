extends Node

const SECRET_CODE := "PEDROSANCHEZ"  # En mayúsculas

var input_buffer := ""

func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		var char := OS.get_keycode_string(event.keycode)
		if char.length() == 1:
			char = char.to_upper()  # Convertimos todo a mayúscula
			input_buffer += char
			input_buffer = input_buffer.substr(max(0, input_buffer.length() - SECRET_CODE.length()), SECRET_CODE.length())

			if input_buffer == SECRET_CODE:
				if $"../Pedrosanchez".visible == true:
					$"../Pedrosanchez".visible = false
				if $"../Pedrosanchez".visible == false:
					$"../Pedrosanchez".visible = true
