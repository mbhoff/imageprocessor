--[[
  * * * * functions.lua * * * *
  
Contains all of the point processing functions for
the program. Each point processing function is passed the image
and several other perameters based on the function, and returns an image.

The helper function clipValues sets values greater than 255 to 255
and less than 0 to 0.

Author: Mark Buttenhoff, Dr. Weiss, Alex Iverson
Class: CSC442 Digital Image Processing
Date: Spring 2017
--]]

local il = require "il"
local math = require "math"

--[[
Function: clipValue  
Clips a value outside the 0-255 range by
setting a value greater than 255 to 255
and less than 0 to 0
--]]
local function clipValue( val )
  
    if val > 255 then do
      val = 255
    end
    end
      
    if val < 0 then do
       val = 0
    end
    end
    
    return val
    
  end

-----------------
-- IP routines --
-----------------

--[[
Function: Negate  
Negates the rgb color values of the image
by subtracting 255 from each rgb value.
--]]
local function negate( img )
  
  return img:mapPixels(function( r, g, b )
      return 255 - r, 255 - g, 255 - b
    end
  )
end


--[[
Function: Grayscale  
Converts an rgb image to grayscale by multiplying
the red value by 30%, green value by 59% and
blue value by 11%, summing the values and replacing
each pixel's color value with that sum.
--]]
local function grayscale( img )
  
  return img:mapPixels(function( r, g, b )
      local sum = r * .30 + g * .59 + b * .11
      return sum, sum, sum
    end
  )
end

--[[
Function: Binary Threshold  
Converts an image to grayscale, then compares
the grayscale intensity of each pixel to
the threshold value passed in. If the
pixel's intensity is greater than the threshhold
it is set to white, otherwise it is set to black.
--]]
local function bthreshold( img, threshold )
  
  return img:mapPixels(function( r, g, b )
    local pixelValue = r * .30 + g * .59 + b * .11

    
      if pixelValue >= threshold
        then pixelValue = 255
      else pixelValue = 0
    end
    
      return pixelValue, pixelValue, pixelValue
    end
    )
end


--[[
Function: Posterize  
Converts an image to a posterized image by
converting the image to yiq, dividing
the image by a delta value (255/number of levels of posterization) + 1
and multiplying by the delta.

That value is floored, and clipped, and returned as the y
value for the new yiq pixel.
--]]
local function posterize( img, levels )
  
  img = il.RGB2YIQ(img)
  
  img = img:mapPixels(function( y, i, q)
      
      local delta = 255 / levels

      y = math.floor (y / delta + 1) * delta
      
      y = clipValue(y)
      
      return y, i, q
    
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end


--[[
Function: Brightness
Increases or decreases the brightness of the image
by adding the brightness passed in to the y of
each pixel in a yiq image. Clips values to
be between 0 and 255.
--]]
local function brightness( img, brightness )

  
  img = il.RGB2YIQ(img)

  
  img = img:mapPixels(function( y, i, q)
      
      y = y + brightness
      y = clipValue(y)
      
      return y, i, q
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
end


--[[
Function: contrastAdjustmentWithLinearRamp
Contrast is adjusted with a linear
ramp between the min and max values passed in.
The y intensity of the pixels is set equal to
( 255 / (ramp max - ramp min) ) * (y - ramp min)
--]]
local function contrastAdjustmentWithLinearRamp( img, min, max )

  
  local img = il.RGB2YIQ(img)
  
  img = img:mapPixels(function( y, i, q)

      y =  ( 255 / (max - min) ) * (y - min)
      
      y = clipValue(y)
      
      return y, i, q
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end


--[[
Function: Gamma
This function modifies the gamma value of the image
by converting to yiq, and applying the following
formula to the y intensity of each pixel:
y = 255 * (y/255)^g
Where g is the gamma value.
The image is clipped so values are between 0 and 255.

--]]
local function gamma( img, g, c )

  
  img = il.RGB2YIQ(img)

  
  img = img:mapPixels(function( y, i, q)
      
      
      y = 255 * (y/255)^g
      y = clipValue(y)
      
      return y, i, q
      
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end


--[[
Function: logTransformation
Applies a log transformation to the image
to modify the dynamic range of the image.

--]]
local function logTransformation( img, g, c )

  
  img = il.RGB2YIQ(img)

  
  img = img:mapPixels(function( y, i, q)
      
      --y = 255 * math.log((y/255)+1)
      y = (math.log(y + 1) / math.log(256)) * 255
      
      y = clipValue(y)
            
      return y, i, q
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end


--[[
Function: discretePseudocolor 
This function adds 8 values of psuedocolor
to an image. The image is converted to greyscale,
and the grayscale value of each pixel is used to assign it
to one of the 8 colors.
--]]
local function discretePseudocolor( img )
  
      
  local table = {}
      for i = 0, 8 do table[i] = i*300 % 255 end
  
  img = img:mapPixels(function( r, g, b)
      
      
      r = table[ math.floor( (r / 32) ) ]
      g = table[ math.ceil( (g / 32) ) ]
      b = table[ math.floor( (b / 32) ) ]
      
      
      return r, g, b
    
    end
  )
  return img
end



--[[
Function: continuousPseudocolor 
This function adds up to 255 values of psuedocolor
to an image. The image is converted to greyscale,
and the grayscale value of each pixel is used as an input to
3 functions - one for r, g, and b values.

These functions are parabolic functions with slight horizontal offsets
from each other so that they overlap some values, creating a gradient
effect.
--]]
local function continuousPseudocolor( img )
  
  img = grayscale(img);
      
  local redTable = {}
      for i = 0, 255 do redTable[i] = math.floor(.03*((i-100)^2)) end
  
  local greenTable = {}
      for j = 0, 255 do greenTable[j] = math.floor(.04*(j+1)^2 + 5) end

  local blueTable = {}
      for k = 0, 255 do blueTable[k] = math.floor(.01*((k+4)^2)) end

  img = img:mapPixels(function( r, g, b)
      
      local temp = r
      
      r = redTable[temp]
      g = greenTable[temp]
      b = blueTable[temp]

      r = clipValue(r)
      g = clipValue(g)
      b = clipValue(b)
    
      return r, g, b
    
    end
  )

  return img
  
end

--[[
Function: automatedContrastStretch 
This function adds a contrast stretch to the image,
with min and max values set to the highest and lowest
intensities in the image.
The y value of the pixels is set to the following formula:
(y - min) * (255 /(max - min))

--]]
local function automatedContrastStretch( img, colormodel )
  
  local min = 255
  local max = 0
  
  img = il.RGB2YIQ(img)
  
  for r, c in img:pixels() do
    if img:at(r,c).yiq[0] < min then min = img:at(r,c).yiq[0]
  elseif img:at(r,c).yiq[0] > max then max = img:at(r,c).yiq[0]
    end
  end
  
  img = img:mapPixels(function( y, i, q)

      --y = constant * (y - min)
      
      y = (y-min) * (255/(max-min))
      
      y = clipValue(y)
      
      return y, i, q
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end


--[[
Function: specifiedContrastStretch 
This function adds a contrast stretch to the image,
for the range of min and max values passed in.
The y value of the pixels is set to the following formula:
(y - min) * (255 /(max - min))

--]]

local function specifiedContrastStretch( img, min, max, colormodel )
    
  img = il.RGB2YIQ(img)
  
  
  local histogram = {}
  for i = 1, 256 do histogram[i] = 0 end
  
  img:mapPixels(function( y, i, q)
      histogram[y+1] = histogram[y+1] + 1
      return y, i, q
    end
  )

  img = img:mapPixels(function( y, i, q)

      --y = constant * (y - min)
      
      y = (y-min) * (255/(max-min))
      
      y = clipValue(y)
      
      return y, i, q
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end


--[[
Function: histogramEqualization
Equalizes the image intensities by creating a
histogram of the intensity values, and a lookupTable
of probability values for each intensity.
The values of the lookup table are assigned through
a recursive assignment:

lookuptable[i] = histogram[i] * alpha + lookuptable[i-1]

The first value in the lookup table is set equal to
the first value in the histogram * alpha(the range of values in
the image / number of pixels in the image)

Then the rest of the values in the lookup tables are set equal
to their cooresponding value in the histogram table * alpha +
the previous value in the lookuptable. This produces a table
of cumulative probability values for each intensity.

Finally the intensities are mapped based on their values in the
lookuptable. In this case because the histogram and lookup
table are 1 indexed, and the pixel rows and columns are 0 indexed,
the pixel intensity values are are mapped to their value at
lookuptable[y+1] 

--]]
local function histogramEqualization(img, colormodel)

  --make histogram
  img = il.RGB2YIQ(img)
  
  local histogram = {}
  for i = 1, 256 do histogram[i] = 0 end
  
  img:mapPixels(function( y, i, q)
      histogram[y+1] = histogram[y+1] +1
      return y, i, q
    end
  )
  
  local a = 256 / (img.width * img.height)
  
  local lookUpTable = {}
  lookUpTable[1] = a * histogram[1]
  for i = 2, 256 do 
    lookUpTable[i] = lookUpTable[i-1] + a * histogram[i]
    lookUpTable[i] = clipValue(lookUpTable[i])
    end
  
  --get probabilities, map to intensities
  img = img:mapPixels(function( y, i, q)
      
  y = lookUpTable[y+1]

  return y, i, q
  
  end
  )

  img = il.YIQ2RGB(img)
  
  return img
end  
  
  
--[[
Function: histogramEqualizationWithClipping
Equalizes the image intensities and clips the percentage
of pixels specified. Creates a histogram of the intensity
values, clipping each intensity frequency to
(pixels in image)*(clip percentage/100).
The sum of all frequencies in the histogram is counted
and used as the new number of pixels when calculating the alpha value
for the cumulative distribution function. The lookupTable stores
cummulative probability values for each intensity.
The intensities are normalized, and set equal to the y value of yiq image.
--]]
local function histogramEqualizationWithClipping(img, clipval, colormodel)

  --make histogram
  img = il.RGB2YIQ(img)
  
  local histogram = {}
  for i = 1, 256 do histogram[i] = 0 end
  
  img:mapPixels(function( y, i, q)
      histogram[y+1] = histogram[y+1] + 1
      return y, i, q
    end
  )
  
  --sum will be used as a count of total number of pixels
  local sum = 0
  
  
  local maxval = (img.width * img.height) * (clipval / 100)

  for i = 1, 256 do      
      if histogram[i] > maxval then histogram[i] = maxval end
      
      sum = sum + histogram[i]
      
    end 
  
    
  local a = 256 / sum
  
  local lookUpTable = {}
  lookUpTable[1] = math.floor((a * histogram[1])+0.5)
  
  for i = 2, 256 do 
    lookUpTable[i] = math.floor( (lookUpTable[i-1] + a * histogram[i])+0.5)
    --lookUpTable[i] = clipValue(lookUpTable[i])
    end
  
  --get probabilities, map to intensities
  img = img:mapPixels(function( y, i, q)
      
    y = lookUpTable[y+1]

    return y, i, q
  
    end
  )

  img = il.YIQ2RGB(img)
  
  return img
  
end


--[[
Function: bitplaneSlice
Gets the image at the bitplane specified.
In this case it is the 0 to 7th bitplane.
To get the image in that bitplane, the image is converted to grayscale,
and the grey values of each pixel are bitwise anded
with a bitstring with the bit of the desired plane flipped.

The result of this bitwise and gives either 0 or a number.
If the result is greater than 0, the value is mapped to 255 (white).
Otherwise the pixel value is mapped to 0 (black).
This produces a black and white binary image.

--]]
local function bitplaneSlice( img, plane )
  
  img = grayscale(img)
  
  local maskTable = {}
    maskTable[0] = 1   --00000001
    maskTable[1] = 2   --00000010
    maskTable[2] = 4   --00000100
    maskTable[3] = 8   --00001000
    maskTable[4] = 16  --00010000
    maskTable[5] = 32  --00100000
    maskTable[6] = 64  --01000000
    maskTable[7] = 128 --10000000
    
  img = img:mapPixels(function( r, g, b)
      
      if bit32.band(r, maskTable[plane]) > 0 then r = 255
      else r = 0
      end
      
      if bit32.band(g, maskTable[plane]) > 0 then g = 255
      else g = 0
      end
      
      if bit32.band(b, maskTable[plane]) > 0 then b = 255
      else b = 0
      end
          
      return r, g, b
    
    end
  )
  return img
  end
  
--[[
Function: imageSubtraction
Subtracts an image from the current image.
The images must be the same size, otherwise the function
will return the original image with no change.
The function subracts the rgb values of each pixel
of the the passed in image from the original image.
--]]
local function imageSubtraction( img1, img2 )
      
    if img1.height ~= img2.height or img1.width ~= img2.width
    then return img1
    end
      
      
    local rows, cols = img1.height, img1.width
    
    for r = 0, rows-1 do
      for c = 0, cols-1 do
        -- negate each RGB channel
        for ch = 0, 2 do
          img1:at(r,c).rgb[ch] = img1:at(r,c).rgb[ch] - img2:at(r,c).rgb[ch]
        end
      end
    end
      
  return img1
end


------------------------------------
-------- exported routines ---------
------------------------------------

return {
  negate = negate,
  grayscale = grayscale,
  bthreshold = bthreshold,
  posterize = posterize,
  brightness = brightness,
  contrastAdjustmentWithLinearRamp = contrastAdjustmentWithLinearRamp,
  gamma = gamma,
  logTransformation = logTransformation,
  discretePseudocolor = discretePseudocolor,
  continuousPseudocolor = continuousPseudocolor,
  specifiedContrastStretch = specifiedContrastStretch,
  automatedContrastStretch = automatedContrastStretch,
  bitplaneSlice = bitplaneSlice,
  histogramEqualization = histogramEqualization,
  histogramEqualizationWithClipping = histogramEqualizationWithClipping,
  imageSubtraction = imageSubtraction,
}
