--[[

  * * * * menu.lua * * * *

Lua image processing program: performs image negation and smoothing.
Menu routines are in menu.lua, IP routines are functions.lua.

Authors: Mark Buttenhoff, Dr. Weiss, Alex Iverson
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

-- LuaIP image processing routines
require "ip"
local viz = require "visual"
local il = require "il"

-- my routines
local myip = require "functions"

-----------
-- menus --
-----------

imageMenu("Point processes",
  {
    
    {"Negate", myip.negate},
    
    {"Binary Threshold", myip.bthreshold, {{name = "threshold", type = "number", displaytype = "slider", default = 128, min = 0, max = 255}}},
    
    {"My Grayscale", myip.grayscale},
    
    {"My Posterize", myip.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    
    {"Increase/Decrease Brightness", myip.brightness, {{name = "brightness", type = "number", displaytype = "spin", default = 0, min = -255, max = 255}}},
  
    {"Contrast Adjustment with Linear Ramp", myip.contrastAdjustmentWithLinearRamp, {{name = "min", type = "number", displaytype = "spin", default = 50, min = 0, max = 255},{name = "max", type = "number", displaytype = "spin",     default = 100, min = 0, max = 255}}},
  
    {"Gamma", myip.gamma, {{name = "gamma", type = "number", displaytype = "textbox", default = "1.0"}, {name = "color model", type = "string", default = "rgb"}}},
    {"Log Transformation", myip.logTransformation, {{name = "input", type = "number", displaytype = "textbox", default = "1.0"}, {name = "color model", type = "string", default = "rgb"}}},
  
    {"Discrete Pseudocolor", myip.discretePseudocolor},
  
    {"Continuous Pseudocolor", myip.continuousPseudocolor},
  
    {"Automated Contrast Stretch", myip.automatedContrastStretch, {{name = "color model", type = "string", default = "yiq"}}},
  
    {"Specified Contrast Stretch\tCtrl-H", myip.specifiedContrastStretch, hotkey = "C-H", {{name = "lp", type = "number", displaytype = "spin", default = 1, min = 0, max = 100}, {name = "rp", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}, {name = "color model", type = "string", default = "yiq"}}},
  
    {"Display Histogram", il.showHistogram,
       {{name = "color model", type = "string", default = "yiq"}}},
  
    {"Bitplane Slice", myip.bitplaneSlice,
      {{name = "plane", type = "number", displaytype = "spin", default = 7, min = 0, max = 7}}},
  
    {"Histogram Equalize", myip.histogramEqualization, {{name = "color model", type = "string", default = "yiq"}}},
  
    {"Histogram Equalize Clip", myip.histogramEqualizationWithClipping,
      {{name = "clip %", type = "number", displaytype = "textbox", default = "1.0"},
       {name = "color model", type = "string", default = "yiq"}}},
  
    {"Image Subtraction", myip.imageSubtraction, {{name = "image", type = "image"}}},
  
}  
)


imageMenu("Help",
  {
    {"Help", viz.imageMessage( "Help", "This program contains several image point processing functions" )},
    
    {"About", viz.imageMessage( "LuaIP " .. viz.VERSION, "Authors: Mark Buttenhoff, John Weiss, and Alex Iverson\nClass: CSC442 Digital Image Processing\nDate: Spring 2017" )},

  }
)



start()
