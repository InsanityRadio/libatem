require_relative './lib/atem'


switcher = ATEM.connect("10.32.0.199")

#p switcher.inputs
#p switcher.inputs[0]

switcher.inputs['Wide'].preview

switcher.inputs['MP1'].program

switcher.use_audio_levels = true

sleep 0.1
loop do
	p switcher.inputs['AES/EBU'].audio.levels
	sleep 0.3
end