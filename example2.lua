--[[

  * * * * example2.lua * * * *

Lua image processing program: performs image negation and smoothing.
Menu routines are in example2.lua, IP routines are negate_smooth.lua.

Author: John Weiss, Ph.D.
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

-- LuaIP image processing routines
require "ip"
require "visual"
local il = require "il"

-- my routines
local myip = require "negate_smooth"

-----------
-- menus --
-----------

imageMenu("Point processes",
  {
    {"Negate", il.negate},
    {"My Negate 1", myip.negate1},
    {"My Negate 2", myip.negate2},
    {"My Grayscale", myip.grayscale},
    {"My Posterize", myip.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    {"Increase/Decrease Brightness", myip.brightness, {{name = "brightness", type = "number", displaytype = "spin", default = 0, min = -255, max = 255}}},
    {"Contrast Stretch", myip.contrast, {{name = "min", type = "number", displaytype = "spin", default = 50, min = 0, max = 255},{name = "max", type = "number", displaytype = "spin", default = 100, min = 0, max = 255}}},
    {"Gamma", myip.gamma, {{name = "gamma", type = "number", displaytype = "textbox", default = "1.0"}, {name = "color model", type = "string", default = "rgb"}}},
    {"Dynamic Range Compression", myip.dynamicRangeCompression, {{name = "input", type = "number", displaytype = "textbox", default = "1.0"}, {name = "color model", type = "string", default = "rgb"}}},
    {"Discrete Pseudocolor", myip.discretePseudocolor},
    {"Continuous Pseudocolor", myip.continuousPseudocolor},
    {"Contrast Stretch", myip.automatedContrastStretch, {{name = "color model", type = "string", default = "yiq"}}},
    {"Contrast Specify\tCtrl-H", myip.specifiedContrastStretch, hotkey = "C-H", {{name = "lp", type = "number", displaytype = "spin", default = 1, min = 0, max = 100}, {name = "rp", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}, {name = "color model", type = "string", default = "yiq"}}},
    {"Display Histogram", il.showHistogram,
       {{name = "color model", type = "string", default = "yiq"}}},
    {"Bitplane Slice", myip.bitplaneSlice,
      {{name = "plane", type = "number", displaytype = "spin", default = 7, min = 0, max = 7}}},
    {"Histogram Equalize", myip.histogramEqualization, {{name = "color model", type = "string", default = "yiq"}}},
    {"Histogram Equalize Clip", myip.histogramWClipping, {{name = "clip %", type = "number", displaytype = "textbox", default = "1.0"}, {name = "color model", type = "string", default = "yiq"}}},
  }
)

imageMenu("Neighborhood processes",
  {
    {"Weighted 3x3 Smooth", il.smooth},
    {"My 3x3 Smooth", myip.smooth},
  }
)

imageMenu("Misc",
  {
    {"Binary Threshold", myip.bthreshold, {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
  }
)



start()
