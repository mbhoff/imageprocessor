--[[

  * * * * negate_smooth.lua * * * *

Lua image processing program: performs image negation and smoothing.
Menu routines are in example2.lua, IP routines are negate_smooth.lua.

Author: John Weiss, Ph.D.
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local il = require "il"
local math = require "math"

--[[  Function to clip values
      greater than 255
      and less than 0
]]--      
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





-- negate/invert image 
-- written by Dr. Weiss
local function negate1( img )
  local nrows, ncols = img.height, img.width

  -- for each pixel in the image
  for r = 0, nrows-1 do
    for c = 0, ncols-1 do
      -- negate each RGB channel
      for ch = 0, 2 do
        img:at(r,c).rgb[ch] = 255 - img:at(r,c).rgb[ch]
      end
    end
  end

  -- return the negated image
  -- note: input image was modified (did not make a copy)
  return img
end

-- negate/invert image using mapPixels
-- written by Dr. Weiss
local function negate2( img )
  return img:mapPixels(function( r, g, b )
      return 255 - r, 255 - g, 255 - b
    end
  )
end

-----------------


-- grayscale image using mapPixels
-- written by Dr. Weiss
local function grayscale( img )
  return img:mapPixels(function( r, g, b )
      local temp = r * .30 + g * .59 + b * .11
      return temp, temp, temp
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





local function dynamicRangeCompression( img, g, c )

  
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










local function contrast( img, min, max )

  
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


local function specifiedContrastStretch( img, min, max, colormodel )

  
  img = il.RGB2YIQ(img)

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


local function automatedContrastStretch( img, colormodel )

  
  img = il.RGB2YIQ(img)

  --local deltax = max - min
  --local deltay = 255
  --local constant = deltay/deltax
  
  img = img:mapPixels(function( y, i, q)

      --y = constant * (y - min)
      
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





local function posterize( img, levels )
  
  img = il.RGB2YIQ(img)

  
  img = img:mapPixels(function( y, i, q)
      
      
      
      
      local delta = 255 / levels
--[[  
      r = math.floor( r / delta) * delta
      g = math.floor( g / delta) * delta
      b = math.floor( b / delta) * delta
--]]

      y = math.floor (y / delta + 1) * delta
      
      y = clipvalue(y)
      
      
      
      return y, i, q
    
    end
  )
  
  img = il.YIQ2RGB(img)
  return img
  end

 
      
--[[
      print(delta)
      a = {}
      for i = 1, levels do a[i] = i*delta end
      
      local count = 1
      while r > a[count] do
        count = count + 1
      end
      
      local red = a[count]
      if red > 255 then red = 255 end
      
      
      count = 1
      while g > a[count]
      do count = count + 1
      end
        
      local blue = a[count]
      if blue > 255 then blue = 255 end
      
      
      count = 1
      while b > a[count]
      do count = count + 1
      end
      
      local green = a[count]
      if green > 255 then green = 255 end
      
      return red, green, blue


    end
  )
  end

--]]





-- 3x3 smoothing
local function smooth( img )
  local nrows, ncols = img.height, img.width

  -- convert image from RGB to YIQ
  img = il.RGB2YIQ( img )

  -- make a local copy of the image
  local res = img:clone()

  -- use pixel iterator over image, instead of nested loops
  -- for r = 1,nrows-2 do for c = 1,ncols-2 do ...
  for r, c in img:pixels(1) do
    -- sum 3x3 neighborhood pixel intensities
    local sum = 0
    for i = -1, 1 do
      for j = -1, 1 do
        sum = sum + img:at(r+i,c+j).y     -- .y is more concise than .rgb[0]
      end
    end
    -- store the neighborhood average
    res:at(r,c).y = sum / 9
  end

  -- convert smoothed image from YIQ to RGB and return the smoothed image
  -- note: input image was not modified (made a copy)
  return il.YIQ2RGB( res )
end

------------------------------------
-------- exported routines ---------
------------------------------------

return {
  grayscale = grayscale,
  bthreshold = bthreshold,
  posterize = posterize,
  brightness = brightness,
  contrast = contrast,
  gamma = gamma,
  dynamicRangeCompression = dynamicRangeCompression,
  discretePseudocolor = discretePseudocolor,
  continuousPseudocolor = continuousPseudocolor,
  specifiedContrastStretch = specifiedContrastStretch,
  automatedContrastStretch = automatedContrastStretch,
  bitplaneSlice = bitplaneSlice,
  
  negate1 = negate1,
  negate2 = negate2,
  smooth = smooth,
}
