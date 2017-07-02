require_relative './lib/atem'


switcher = ATEM.connect("10.32.0.199")

p switcher.inputs
p switcher.inputs[0]

p switcher.inputs['Wide'].preview
p switcher.inputs['Pres'].program