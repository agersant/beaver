return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "1.0.3",
  orientation = "isometric",
  renderorder = "right-down",
  width = 20,
  height = 20,
  tilewidth = 32,
  tileheight = 16,
  nextobjectid = 108,
  properties = {},
  tilesets = {
    {
      name = "canada",
      firstgid = 1,
      filename = "../../../source/tileset/canada.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../tileset/canada.png",
      imagewidth = 320,
      imageheight = 320,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 100,
      tiles = {
        {
          id = 1,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {
              ["slopeSW"] = true
            },
            objects = {}
          }
        },
        {
          id = 2,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {
              ["slopeSE"] = true
            },
            objects = {}
          }
        },
        {
          id = 3,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {
              ["slopeNW"] = true
            },
            objects = {}
          }
        },
        {
          id = 4,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            offsetx = 0,
            offsety = 0,
            draworder = "index",
            properties = {
              ["slopeNE"] = true
            },
            objects = {}
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Tile Layer 1",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      name = "Tile Layer 2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -8,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Copy of Tile Layer 2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -16,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Copy of Copy of Tile Layer 2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -24,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Copy of Copy of Copy of Tile Layer 2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -32,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Copy of Copy of Copy of Copy of Tile Layer 2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -40,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      name = "Copy of Copy of Copy of Copy of Copy of Tile Layer 2",
      x = 0,
      y = 0,
      width = 20,
      height = 20,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -48,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "Object Layer 1",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = -56,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 2,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 3,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 4,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 5,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 6,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 7,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 8,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 9,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 10,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 11,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 12,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 48,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 13,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 14,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 15,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 16,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 17,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 18,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 19,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 20,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 21,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 22,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 23,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 24,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 64,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 25,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 26,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 27,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 28,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 29,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 30,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 31,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 32,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 33,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 34,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 35,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 36,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 37,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 38,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 39,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 40,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 41,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 42,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 43,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 44,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 45,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 46,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 47,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 96,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 48,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 80,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 49,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 50,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 51,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 52,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 53,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 54,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 55,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 56,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 57,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 58,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 59,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 60,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 61,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 62,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 63,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 64,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 65,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 66,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 67,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 68,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 69,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 70,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 71,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 128,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 72,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 112,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 73,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 74,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 75,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 76,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 77,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 78,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 79,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 80,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 81,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 82,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 83,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 84,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 85,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 86,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 87,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 88,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 89,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 90,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 91,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 92,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 93,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 94,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 95,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 160,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 96,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 144,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 97,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 160,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 98,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 176,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 99,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 144,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 100,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 101,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 240,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 102,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 192,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 103,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 256,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 104,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 208,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 105,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 96,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 106,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 112,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        },
        {
          id = 107,
          name = "",
          type = "fill",
          shape = "rectangle",
          x = 176,
          y = 224,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {
            ["height"] = 6
          }
        }
      }
    }
  }
}
