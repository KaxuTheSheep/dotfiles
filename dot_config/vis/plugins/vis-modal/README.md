<div align="center">
	<h1>
		modal
	</h1>
</div>

<div align="center">
	a status line colorizer for vis
</div>

# Installation
To install vis-modal, clone this repository in your `~/.config/vis/plugins/` directory:
```
git clone https://git.symlinx.net/vis-modal ~/.config/vis/plugins/vis-modal
```
Then, you can use it with the default configuration by putting this into your `~/.config/vis/visrc.lua`:
```lua
local modal = require('plugins/vis-modal')
```

# Customization
You can change the colors and mode descriptors in vis-modal to your liking, with this template:
```
local modal = require('plugins/vis-modal')

modal.MODES = {
	[vis.modes.NORMAL] = ' NORMAL ',
	[vis.modes.INSERT] = ' INSERT ',
	[vis.modes.VISUAL] = ' VISUAL ',
	[vis.modes.REPLACE] = ' REPLACE ',
	[vis.modes.VISUAL_LINE] = ' VISUAL_LINE ',
	[vis.modes.OPERATOR_PENDING] = ' OPERATOR_PENDING '
}

modal.STYLES = {
	[vis.modes.NORMAL] = {
		REGULAR = 'fore:default,back:yellow',
		INVERTED = 'fore:yellow,back:black',
	},
	[vis.modes.INSERT] = {
		REGULAR = 'fore:default,back:green',
		INVERTED = 'fore:green,back:black',
	},
	[vis.modes.VISUAL] = {
		REGULAR = 'fore:default,back:magenta',
		INVERTED = 'fore:magenta,back:black',
	},
	[vis.modes.REPLACE] = {
		REGULAR = 'fore:default,back:blue',
		INVERTED = 'fore:blue,back:black',
	},
	[vis.modes.VISUAL_LINE] = {
		REGULAR = 'fore:default,back:magenta',
		INVERTED = 'fore:magenta,back:black',
	},
	[vis.modes.OPERATOR_PENDING] = {
		REGULAR = 'fore:default,back:blue',
		INVERTED = 'fore:blue,back:black',
	},
	UNFOCUSED = {
		REGULAR = 'fore:default,back:white',
		INVERTED = 'fore:white,back:black',
	},
}
```
