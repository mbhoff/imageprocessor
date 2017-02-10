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
    {"Help", viz.imageMessage( "Help", "Select any of the following point processing functions in the menu to perform the operation on the image in the current tab:\n\nNegate: Inverts the image\n\nGrayscale: Convert image to grayscale\n\nBinary Threshold: Converts image to a black and white binary image. Inputs - threshold (0-255)\n\nPosterize: Converts image to a posterized image. Inputs - number of posterization levels (2-64)\n\nBrightness: Increases or decreases image brightness. Input brightness adjustment value (-255 to +255)\n\nContrast Adjustment With Linear Ramp:\nInputs - ramp min and max (0-255)\n\nGamma: Adjusts image gamma. Input gamma increase or decrease value.\n\nLog Transformation\n\nDiscrete Pseudocolor\n\nContinuous Pseudocolor\n\nSpecified Contrast Stretch\n\nAutomated Contrast Stretch\n\nBitplane Slice: enter bit plane (0-7)\n\nHistogram Equalization\n\nHistogram Equalization With Clipping: input percentage of intensities to clip\n\nImage Subtraction: Select image to subtract. Image must have the same dimensions as image in the current tab." )},
    
    {"About", viz.imageMessage( "LuaIP " .. viz.VERSION, "Authors: Mark Buttenhoff, John Weiss, and Alex Iverson\nClass: CSC442 Digital Image Processing\nDate: Spring 2017" )},
  }
)



start()
