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


local function bthreshold( img, threshold )
  
  return img:mapPixels(function( r, g, b )
    local temp = r * .30 + g * .59 + b * .11

    
      if temp >= threshold
        then temp = 255
      else temp = 0
    end
    
      return temp, temp, temp
    end
    )
end



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



local function contrastAdjustmentWithLinearRamp( img, min, max )

  
  local img = il.RGB2YIQ(img)

  local deltax = max - min
  local deltay = 255
  local constant = deltay/deltax
  
  img = img:mapPixels(function( y, i, q)

      y = constant * (y - min)
      
      y = clipValue(y)
      
      return y, i, q
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end



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
  
local function bitplaneSlice( img, plane )
  
  img = grayscale(img)
  
  local maskTable = {}
    maskTable[0] = 1
    maskTable[1] = 2
    maskTable[2] = 4
    maskTable[3] = 8
    maskTable[4] = 16
    maskTable[5] = 32
    maskTable[6] = 64
    maskTable[7] = 128
    
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
