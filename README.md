# <img src="https://raw.githubusercontent.com/InsanityRadio/OnAirController/master/doc/headphones_dark.png" align="left" height=48 /> libatem

libatem is a Ruby library that can control ATEM switchers.

# Basic usage

```
switcher = ATEM.connect("10.32.0.199")

switcher.inputs

=> []

switcher.inputs[1]
switcher.inputs['Camera 1']

switcher.inputs[0].preview
switcher.inputs[1].program


```