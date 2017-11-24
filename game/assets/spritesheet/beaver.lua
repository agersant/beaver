local w = 32;
local h = 32;
local ox = 16;
local oy = 24;

return {
	type = "spritesheet",
	content = {
		texture = "assets/spritesheet/beaver.png",
		frames = {
			idle_0_NE = { x = 0 * w, y = 0, w = w, h = w, ox = ox, oy = oy },
			idle_0_NW = { x = 1 * w, y = 0, w = w, h = w, ox = ox, oy = oy },
			idle_0_SE = { x = 2 * w, y = 0, w = w, h = w, ox = ox, oy = oy },
			idle_0_SW = { x = 3 * w, y = 0, w = w, h = w, ox = ox, oy = oy },
		},
		animations = {
			idle_NE = { frames = { { id = "idle_0_NE" } } },
			idle_NW = { frames = { { id = "idle_0_NW" } } },
			idle_SE = { frames = { { id = "idle_0_SE" } } },
			idle_SW = { frames = { { id = "idle_0_SW" } } },
		},
	},
};