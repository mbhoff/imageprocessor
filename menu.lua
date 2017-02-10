--[[

  * * * * menu.lua * * * *

Lua image processing program: performs image negation and smoothing.
Menu routines are in menu.lua, IP routines are functions.lua.

Authors: Mark Buttenhoff, Dr. Weiss, Alex Iverson
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

LUA IP Program Description:
This program performs several point processing operations on
images.

Negate: Inverts the image by subtracting the images rgb values from 255.
Grayscale: Converts image to grayscale by setting each rgb value to r * .30 + g * .59 + b * .11
Binary Threshold: Converts image to a black and white binary image. Inputs - threshold (0-255)
Posterize: Converts image to a posterized image. Inputs - number of posterization levels (2-64)
Brightness: Increases or decreases image brightness. Input brightness adjustment value (-255 to +255)
Contrast Adjustment With Linear Ramp: Inputs - Ramp min and max (0-255)
Gamma: Adjusts image gamma. Input gamma increase or decrease value.
Log Transformation: Performs a log transformation on the image.
Discrete Pseudocolor: Maps the image to 8 color values.
Continuous Pseudocolor - Maps the image to 256 color values
Specified Contrast Stretch: Performs contrast stretch with specifid min and max. Inputs - min and max percentages of light and dark pixels to ignore
Automated Contrast Stretch: Performs a contrast stretch with the min and max set to the lowest and highest intensity frequencies in the image.
Bitplane Slice: Gets image at inputted bit plane. Inputs - bit plane (0-7)
Histogram Equalization - Performs Histogram Equalization resulting in a balanced contrast image
Histogram Equalization With Clipping: input percentage of intensities to clip
Image Subtraction: Select image to subtract. Image must have the same dimensions as image in the current tab.

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
    
    {"Grayscale", myip.grayscale},
    
    {"Posterize", myip.posterize, {{name = "levels", type = "number", displaytype = "spin", default = 8, min = 2, max = 64}}},
    
    {"Increase/Decrease Brightness", myip.brightness, {{name = "brightness", type = "number", displaytype = "spin", default = 0, min = -255, max = 255}}},
  
    {"Contrast Adjustment with Linear Ramp", myip.contrastAdjustmentWithLinearRamp, {{name = "min", type = "number", displaytype = "spin", default = 50, min = 0, max = 255},{name = "max", type = "number", displaytype = "spin",     default = 100, min = 0, max = 255}}},
  
    {"Gamma", myip.gamma, {{name = "gamma", type = "number", displaytype = "textbox", default = "1.0"}, {name = "color model", type = "string", default = "rgb"}}},
    
    {"Log Transformation", myip.logTransformation},
  
    {"Discrete Pseudocolor", myip.discretePseudocolor},
  
    {"Continuous Pseudocolor", myip.continuousPseudocolor},
  
    {"Automated Contrast Stretch", myip.automatedContrastStretch, {{name = "color model", type = "string", default = "yiq"}}},
  
    {"Specified Contrast Stretch", myip.specifiedContrastStretch, hotkey = "C-H", {{name = "lp", type = "number", displaytype = "spin", default = 1, min = 0, max = 100}, {name = "rp", type = "number", displaytype = "spin", default = 99, min = 0, max = 100}, {name = "color model", type = "string", default = "yiq"}}},
  
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
    {"Help", viz.imageMessage( "Help", "Select any of the following point processing functions in the menu to perform the operation on the image in the current tab:\n\nNegate: Inverts the image\nGrayscale: Converts image to grayscale\nBinary Threshold: Converts image to a black and white binary image. Inputs - threshold (0-255)\nPosterize: Converts image to a posterized image. Inputs - number of posterization levels (2-64)\nBrightness: Increases or decreases image brightness. Input brightness adjustment value (-255 to +255)\nContrast Adjustment With Linear Ramp:\nInputs - ramp min and max (0-255)\nGamma: Adjusts image gamma. Input gamma increase or decrease value.\nLog Transformation: Performs a log transformation on the image.\nDiscrete Pseudocolor: Maps the image to 8 color values.\nContinuous Pseudocolor - Maps the image to 256 color values\nSpecified Contrast Stretch: Performs contrast stretch with specifid min and max. Inputs - min and max percentages of light and dark pixels to ignore\nAutomated Contrast Stretch - Performs a contrast stretch with the min and max set to the lowest and highest intensity frequencies in the image.\nBitplane Slice: Gets image at inputted bit plane. Inputs - bit plane (0-7)\nHistogram Equalization - Performs Histogram Equalization resulting in a balanced contrast image\nHistogram Equalization With Clipping: input percentage of intensities to clip\nImage Subtraction: Select image to subtract. Image must have the same dimensions as image in the current tab." )},
    
    {"About", viz.imageMessage( "LuaIP " .. viz.VERSION, "Authors: Mark Buttenhoff, Dr. Weiss, and Alex Iverson\nClass: CSC442 Digital Image Processing\nDate: Spring 2017" )},
  }
)



start()
